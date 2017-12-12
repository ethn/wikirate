class Card
  class FormulaAnswerDetailsTable < AnswerDetailsTable
    @columns = ["Original Metric", "Value"]

    def table_rows
      [metric_row(base_metric_card)]
    end

    def value
      @format.wrap_with(:span, base_metric_value.value, class: "metric-value")
    end

    def base_metric_card
       @format.card.metric_card.left
     end

     def base_metric_value
       base_metric_card.field(company).field(year)
     end
  end
end
