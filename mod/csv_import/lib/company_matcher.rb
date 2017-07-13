class CompanyMatcher
  COMPANY_MAPPER_THRESHOLD = 0.5

  MATCH_TYPE_ORDER= { none: 1, partial: 2, alias: 3, exact: 4 }

  def initialize company_name
    @company_name = company_name
    @match_result = nil
  end

  def match
    find_match
    @match_result
  end

  def suggestion
    none? ? @company_name : match_name
  end

  def match_type
    match[1]
  end

  def match_name
    match[0]
  end

  def exact?
    match_type == :exact
  end

  def none?
    match_type == :none
  end

  def <=> b
    MATCH_TYPE_ORDER[match_type] <=> MATCH_TYPE_ORDER[b.match_type]
  end

  private

  def find_match
    return if @match_result ||
              find_exact_match || find_alias_match || find_partial_match
    @match_result = ["", :none]
  end

  def find_exact_match
    return unless (company = Card.quick_fetch(@company_name)) &&
                  company.type_id == Card::WikirateCompanyID
    @match_result = [company.name, :exact]
  end

  def find_alias_match
    return unless (alias_name = self.class.alias_map[@company_name.downcase])
    [alias_name, :alias]
  end

  def find_partial_match
    id = self.class.mapper.map(@company_name, COMPANY_MAPPER_THRESHOLD)
    return unless id && (name = Card.fetch_name(id))
    [name, :partial]
  end

  def self.alias_map
    @aliases_hash ||= begin
      all_alias_cards.each_with_object({}) do |aliases_card, aliases_hash|
        aliases_card.item_names.each do |name|
          aliases_hash[name.downcase] = aliases_card.cardname.left
        end
      end
    end
  end

  def self.all_alias_cards
    Card.search right: "aliases", left: { type_id: Card::WikirateCompanyID }
  end

  def self.mapper
    @mapper ||=
      begin
        corpus = Company::Mapping::CompanyCorpus.new
        Card.search(type_id: Card::WikirateCompanyID, return: :id).each do |company_id|
          company_name = Card.fetch_name(company_id)
          aliases = (a_card = Card[company_name, :aliases]) && a_card.item_names
          corpus.add company_id, company_name, (aliases || [])
        end
        Company::Mapping::CompanyMapper.new corpus
      end
  end
end