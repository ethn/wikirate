# encoding: UTF-8

class Calculate
  # handle outputs for a given answer
  class Calculation
    attr_reader :company_id, :year, :value, :verification, :unpublished

    def initialize calculator, input_answers, company_id, year
      @company_id = company_id
      @year = year
      @input_answers = input_answers

      @value = calculator.result_value map(:value), company_id, year

      # trigger calculation
      verification
      unpublished

      @input_answers = nil # don't keep input_answers (or calculator) in memory
    end

    def answer_attributes
      {
        company_id: company_id,
        year: year,
        value: value,
        numeric_value: Answer.to_numeric(value),
        created_at: Time.now,
        updated_at: Time.now,
        creator_id: Card::Auth.current_id,
        editor_id: Card::Auth.current_id,
        imported: false,
        calculating: false,
        latest: false,
        unpublished: unpublished,
        verification: verification
      }
    end

    private

    def determine_unpublished
      @unpublished = map(:unpublished).find(&:present?) || false
    end

    def determine_verification
      @verification = map(:verification).compact.min || 1
    end

    def map field
      @input_answers.map { |a| a&.send field }
    end
  end
end
