# Lookup table for relationship answers to relationship metrics
class Relationship < ApplicationRecord
  @card_column = :relationship_id
  @card_query = {  type_id: Card::RelationshipAnswerID, trash: false }

  include LookupTable
  include LookupTable::Latest
  include EntryFetch
  include Csv

  after_destroy :latest_to_true
  delegate :company_id, :designer_id, :title_id, to: :answer
  fetcher :answer_id, :value, :numeric_value, :imported

  # other relationships in same record
  def latest_context
    Relationship
      .where(subject_company_id: subject_company_id, metric_id: metric_id)
      .where.not(id: id)
  end

  def company_key
    company_name.to_name.key
  end

  def metric_key
    metric_name.to_name.key
  end

  def updater_id
    editor_id || creator_id
  end

  def delete_on_refresh?
    super() || (!metric_card&.hybrid? && invalid?)
    # when we override a hybrid metric the answer is invalid because of the
    # missing answer_id, so we check `invalid?` only for non-hybrid metrics)
  end

  private

  def metric_card
    @metric_card ||= Card[metric_id]
  end

  def metric_name
    metric_id.cardname
  end

  def subject_company_name
    subject_company_id.cardname
  end

  def object_company_name
    object_company_id.cardname
  end

  def unknown? val
    Answer.unknown? val
  end
end
