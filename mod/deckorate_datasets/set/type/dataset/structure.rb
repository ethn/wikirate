format :html do
  before :content_formgroups do
    voo.edit_structure =
      %i[image parent topic year wikirate_company metric description]
  end

  view :right_column do
    wrap_with(:div, class: "progress-column") { [render_type_link, render_tabs] }
  end

  def tab_list
    %i[details metric_answer wikirate_company metric data_subset]
  end

  def tab_options
    { metric_answer: { count: card.answers.count } }
  end

  view :wikirate_company_tab do
    field_nest :wikirate_company, view: :filtered_content, show: :menu_block
  end

  view :metric_tab do
    field_nest :metric, view: :filtered_content, show: :menu_block
  end

  view :metric_answer_tab do
    [field_nest(:metric_answer, view: :filtered_content), render_import_links]
  end

  # view :project_tab, template: :haml
  view :data_subset_tab, template: :haml

  view :details_tab_right do
    labeled_fields do
      [
        labeled_field(:topic, :link, title: "Topics"),
        labeled_field(:year, :name, title: "Years", unknown: :blank, separator: ", "),
        labeled_field(:project, :thumbnail, title: "Projects")
      ]
    end
  end

  view :details_tab_left do
    field_nest :description
  end

  def copied_dataset_fields
    %i[topic description].each_with_object({}) do |fld, hash|
      hash["_#{fld.cardname}"] = card.fetch(fld, new: {}).content
    end
  end
end
