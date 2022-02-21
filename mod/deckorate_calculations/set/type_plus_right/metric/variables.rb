include_set Abstract::Pointer
include_set Abstract::IdPointer
include_set Abstract::MetricChild, generation: 1

# FIXME: make sure not calculated twice when updated in same act as formula
event :update_calculated_answers, :integrate_with_delay,
      on: :save, changed: :content, priority: 5, when: :content? do
  metric_card.deep_answer_update
end

event :validate_metric_items do
  item_ids.each do |card_id|
    errors.add "unknown id: #{card_id}" unless (card = card_id.card)
    errors.add "not a metric: #{card.name}" unless card.type_id == MetricID
  end
end

def check_json_syntax
  self.content = content # trigger standardization
  super
end

def standardize_content content
  items = content_to_hash_list content
  items.each { |hash| hash["metric"] = standardize_item hash["metric"] }
  items.to_json
end

def item_strings _args={}
  parse_content.map { |item_hash| item_hash["metric"] }
end

def hash_list
  @hash_list ||= parse_content.map(&:symbolize_keys!)
end

def export_content
  db_content
end

def input_array
  (content.present? ? parse_content : [])
end

private

def content_to_hash_list content
  case content
  when Array
    items
  when (/^\s*\[/)
    JSON.parse content
  else
    items_from_simple content
  end
end

def items_from_simple content
  content.to_s.split(/\n+/).map do |variable|
    { "metric" => variable }
  end
end

format :html do
  def input_type
    metric_card.variables_input_type
  end

  def default_item_view
    :bar
  end

  def filter_card
    :metric.card
  end
end
