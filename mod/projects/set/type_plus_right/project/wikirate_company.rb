include_set Abstract::Table

def project_name
  name.left
end

def company_project_card company_card
  Card.fetch company_card.name, project_name, new: {}
end

def valid_company_cards
  @valid_company_cards ||=
    item_cards.sort_by(&:name).select do |company|
      company.type_id == WikirateCompanyID
    end
end

def all_company_project_cards
  valid_company_cards.map do |company|
    company_project_card company
  end
end

format :html do
  view :core do
    wrap_with :div, class: "progress-bar-table" do
      company_progress_table
    end
  end

  def company_progress_table
    wikirate_table(
      :company, card.all_company_project_cards,
      [:company_thumbnail, :research_button, :research_progress_bar],
      header: ["Company", "", "Metrics Researched"],
      table: { class: "company-research" },
      td: { classes: ["metric", "button-column", "progress-column"] }
    )
  end
end
