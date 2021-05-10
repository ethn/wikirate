module Formula
  # This "Calculator" class replicates the behavior of
  # more sophisticated Formula::Calculator classes but performs a much
  # simpler "calculation" - it just takes values from company fields
  # and creates metric answers out of them.
  class CompanyField < Calculator
    YEAR = "2019".freeze

    attr_reader :field_code

    def initialize field_code, opts={}
      @value_normalizer = opts[:value_normalizer]
      @field_code = field_code
      @format = opts[:format]
      @errors = []
    end

    # company fields don't depend on any other answers
    def answers _opts
      []
    end

    # formula is always valid
    def compile_formula
      true
    end

    def result opts={}
      requiring_year opts[:year], {} do
        { YEAR => company_id_to_value_hash(opts[:company]) }
      end
    end

    def result_scope opts={}
      requiring_year opts[:year], [] do
        company_fields(opts[:company]).map do |field_card|
          [field_card.left_id, YEAR]
        end
      end
    end

    def inputs_for _company, _year
      []
    end

    def formula_for company, year
      requiring_year year, "No value" do
        "Pulled from #{field_name} field of #{@format.link_to_card company}"
      end
    end

    private

    def company_id_to_value_hash company
      company_fields(company).each_with_object({}) do |field_card, hash|
        hash[field_card.left_id] = field_card.answer_value
      end
    end

    def company_fields company
      if company
        company_id = company.card_id
        Card.search left_id: company_id, right_id: field_id
      else
        Card.search left: { type_id: Card::WikirateCompanyID }, right_id: field_id
      end
    end

    def requiring_year year, default_result
      if year && year.to_s != YEAR
        default_result
      else
        yield
      end
    end

    def field_id
      Card::Codename.id field_code
    end

    def field_name
      field_code.cardname
    end
  end
end