format :html do
  view :bar_left, template: :haml

  view :bar_middle do
    count_badges :wikirate_company, :metric
  end

  view :bar_right do
    wrap_with :div, class: "text-left d-block w-100" do
      [small_download_link, fancy_year_list]
    end
  end

  def small_download_link
    wrap_with :small, download_link
  end

  view :bar_bottom do
    add_name_context
    output [render_bar_middle,
            field_nest(:report_type,
                       view: :labeled, title: "Report Type", items: { view: :name }),
            field_nest(:wikirate_topic,
                       view: :labeled, title: "Topics", items: { view: :link }),
            field_nest(:description, view: :titled, title: "Description")]
  end

  def year_list
    card.year_card.item_names || []
  end

  def fancy_year_list
    years = year_list
    wrap_with :div, class: "fancy-year-list" do
      years.any? ? years.unshift(year_icon) : []
    end
  end

  def year_icon
    wrap_with :span, fa_icon("calendar"), class: "pr-1"
  end

  def wrap_data slot=true
    super.merge year: year_list.to_json
  end

  def wrap_with_info
    class_up "card-slot", "_citeable-source", true
    wrap do
      wrap_with :div, class: "source-info-container" do
        yield
      end
    end
  end

  def with_toggle
    # voo.hide! :links   # doesn't work with voo
    @links = false
    class_up "card-slot", "source-details-toggle", true
    yield
  end

  def website_text
    field_nest :wikirate_website, view: :content, items: { view: :name }
  end

  def title_text
    field_nest :wikirate_title, view: :needed
  end

  view :icon do
    icon = wrap_with(:i, " ", class: "glyphicon glyphicon-link")
    wrap_with(:div, icon, class: "source-icon")
  end

  view :creator_credit do
    wrap_with :div, class: "last-edit" do
      "added #{_render_created_at} ago by #{creator}"
    end
  end

  view :source_link do
    wrap_with :div, class: "source-link d-block" do
      [wrap_with(:div, source_title, class: "source-title"),
       wrap_with(:div, website_text, class: "source-website text-muted")]
    end
  end

  view :title_link do
    link_to_card card, title_text,
                 target: "_blank",
                 class: "source-preview-link preview-page-link"
  end

  view :direct_link do
    return unless card.link?
    link = card.fetch(trait: :wikirate_link).content
    wrap_with :a, href: link, target: "_blank" do
      [fa_icon("external-link-square", class: "cursor"), "Original"]
    end
  end

  view :listing_compact, template: :haml

  view :content do
    add_name_context
    super()
  end

  view :missing do
    _view_link
  end

  def with_links?
    @links != false
  end

  def source_website
    with_links? ? _render_website_link : website_text
  end

  def source_title
    with_links? ? _render_title_link : title_text
  end

  def creator
    return unless (creator_card = Card[card.creator_id])
    field_nest creator_card, view: :link
  end
end
