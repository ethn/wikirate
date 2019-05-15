include_set Abstract::RightFilterForm
include_set Abstract::FilterFormgroups

def filter_keys
  %i[year status]
end

def advanced_filter_keys
  %i[wikirate_company value updated check project]
end

def default_filter_option
  { year: :latest, status: :exists }
end

format :html do
  def metric_card
    @metric_card ||= card.left.metric_card
  end

  view :filter_value_formgroup do
    case metric_card.value_type_code
    when :category, :multi_category
      multiselect_filter :value
    when :number, :money
      range_filter :value
    else
      super()
    end
  end

  delegate :value_options, to: :metric_card
end

# no sort options because sorting is done by links
# in the header of the table
