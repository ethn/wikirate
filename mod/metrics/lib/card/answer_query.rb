class Card
  # Query lookup table for researched answers
  # (See #new for handling of not-researched)
  class AnswerQuery
    include Filtering
    include AnswerFilters
    include MetricAndCompanyFilters
    include Where

    # instantiates AllAnswerQuery object for searches that can return
    # not-researched answers (status = :all or :none) and AnswerQuery
    # objects for all other searches
    def self.new filter, sorting={}, paging={}
      filter.deep_symbolize_keys!
      if filter[:status]&.to_sym.in?(%i[all none]) && self != AllAnswerQuery
        AllAnswerQuery.new filter, sorting, paging
      else
        super
      end
    end

    def initialize filter, sorting={}, paging={}
      @filter_args = filter
      @sort_args = sorting
      @paging_args = paging

      @conditions = []
      @values = []
      @restrict_to_ids = {}

      process_sort
      process_filters
    end

    # TODO: support optionally returning answer objects

    # @return array of metric answer card objects
    #   if filtered by missing values then the card objects
    #   are newly instantiated and not in the database
    def run
      run_result { sort_and_page { answer_query }.answer_cards }
    end

    def count
      count_result { answer_query.count }
    end

    def count_by_group group
      answer_query.group(group).count
    end

    def count_by_status
      if status_filter.in? %i[all exists]
        count_by_status_groups
      else
        { status_filter => count }
      end
    end

    def count_by_status_groups
      raw_counts = count_by_group "value <> 'Unknown'"
      counts = { total: 0 }
      status_groups.each do |k, v|
        num = raw_counts[v].to_i
        counts[k] = num
        counts[:total] += num
      end
      counts
    end

    def limit
      @paging_args[:limit]
    end

    private

    def status_groups
      { unknown: 0, known: 1 }
    end

    def status_filter
      @filter_args[:status]&.to_sym || :exists
    end

    def run_result
      @empty_result ? [] : yield
    end

    def count_result
      @empty_result ? 0 : yield
    end

    def answer_query
      Answer.where answer_conditions
    end

    def sort_and_page
      yield.sort(@sort_args).paging(@paging_args)
    end

    def process_filters
      @filter_args.each { |k, v| process_filter_option k, v if v.present? }
      @restrict_to_ids.each { |k, v| filter k, v }
    end

    def process_sort
      return unless numeric_sort?

      @sort_args[:sort_by] = :numeric_value
    end

    def numeric_sort?
      single_metric? &&
        @sort_args[:sort_by]&.to_sym == :value &&
        (metric_card.numeric? || metric_card.relationship?)
    end
  end
end
