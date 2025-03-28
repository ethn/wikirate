format :html do
  view :mini_badge, template: :haml

  view :category_badge do
    return "" unless card.topic_families?

    nest card.topic_family, view: :mini_badge
  end

  view :bar_left do
    render_thumbnail + render_category_badge
  end

  view :bar_middle do
    result_middle { count_badges :research_group, :dataset }
  end

  view :bar_right do
    [count_badge(:metric), render_bookmark]
  end

  view :bar_bottom do
    [render_bar_middle, render_details_tab_right, render_details_tab_left]
  end

  view :box_middle do
    field_nest :image, view: :core, size: :medium
  end

  view :box_bottom do
    count_badges :metric, :dataset
  end
end
