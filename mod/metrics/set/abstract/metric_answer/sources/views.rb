format :html do
  delegate :cited?, to: :card

  view :sourcebox, unknown: true, cache: :never do
    wrap { haml :sourcebox }
  end

  view :sources do
    output [citations_count,
            nest(card.source_card, view: :core, items: { view: :bar })]
  end

  view :source_editor do
    with_nest_mode :normal do
      field_nest :source, view: :core, items: { view: :cite_bar }
    end
  end

  view :source_tab, cache: :never, unknown: true do
    if focal? || editing_answer?
      render_source_selector
    elsif !card.metric_card.researchable?
      not_researchable
    else
      source_previews
    end
  end

  view :new_source_form, unknown: true, cache: :never do
    params[:answer] = card.name
    params[:source_url] = source_search_term if source_search_term&.url?
    source_card = Card.new type_id: Card::SourceID
    nest source_card, view: :new
  end

  view :source_selector, cache: :never, unknown: true do
    wrap { haml :source_selector }
  end

  view :my_sources, cache: :never, unknown: true do
    source_list "Sources I added", my_sources
  end

  view :suggested_sources, cache: :never, unknown: true do
    source_list "Suggested Sources", suggested_sources
  end

  view :source_results, cache: :never, unknown: true do
    when_searching do |results|
      if results.present?
        @already_added = results
        already_added results
      else
        render_new_source_form
      end
    end
  end

  def suggested_sources
    without_already_added { card.suggested_sources }
  end

  def my_sources
    without_already_added { card.my_sources }
  end

  def without_already_added
    yield.tap do |results|
      results.reject! { |r| r.in? @already_added } if @already_added.present?
    end
  end

  def source_previews
    return "" unless (first_source = card.source_card.first_card)
    nest first_source, view: :preview
  end

  def editing_answer?
    return true if card.unknown?
    root.voo&.root&.ok_view&.to_sym == :edit
  end

  def already_added results
    output [render_sourcebox, source_list("Sources Already Added", results)]
  end

  # view :freshen_form, cache: :never, unknown: true do
  #   return unless params[:freshen_source]
  #   render_new_source_form
  # end

  def when_searching
    return "" unless params[:button] == "source_search"
    yield raw_source_results
  end

  def raw_source_results
    return [] unless source_search_term.present?
    sources_found_by_url
  end

  def source_search_term
    Env.params[:source_search_term]
  end

  def sources_found_by_url
    return unless source_search_term.url?
    wikirate_source_from_url || Self::Source.search_by_url(source_search_term)
  end

  def wikirate_source_from_url
    mdata = source_search_term.match(%r{//wikirate\.org/(.*)$})
    return unless mdata && (source_card = Card[mdata[1]])
    [source_card]
  end

  def source_list label, sources
    return "" unless sources.any?
    haml :source_list, category_label: label, sources: sources
  end

  def citations_count_badge
    wrap_with :span, card.source_card&.item_names&.size, class: "badge badge-light border"
  end

  def citations_count
    wrap_with :h5, class: "w-100 text-left" do
      [citations_count_badge, "Citations"]
    end
  end
end
