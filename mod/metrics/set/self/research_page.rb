card_accessor :metric
card_accessor :wikirate_company

format :html do
  view :new do
    voo.hide :menu
    frame do
      [
        _render_landing_form,
        render_haml(:source_container)
      ]
    end
  end

  view :core, cache: :never do
    return _render_new unless companies && metrics
    wrap do
      render_haml :new_metric_value_form
    end
  end

  view :company do
    nest companies.first, view: :thumbnail
  end

  def companies
    params[:company] || card.wikirate_company_card.item_names
  end

  def metrics
    if project
      project.field(:metric).item_names
    else
      params[:metric] || card.metric_card.item_names
    end
  end

  view :source_side do
    render_haml :source_side
  end


  view :landing_form, cache: :never do
    html_class = "col-md-5 border-right panel-default min-page-height"
    wrap_with :div, class: html_class do
      card_form :update, success: { view: :core } do
        [
          hidden_source_field,
          company_field, hr,
          metric_field,
          next_button
        ]
      end
    end
  end

  def process_metrics
    metrics.map do |metric_name|
      next not_a_metric(metric_name) unless existing_metric? metric_name
      record_card = Card.fetch metric_name, companies.first, new: {}
      nest record_card, view: :core, hide: :chart
    end.join "\n"
  end

  def project?
    project_name.present?
  end

  def project_name
    Env.params["project"]
  end

  def project
    return unless project?
    unless Card.exists? project_name
      card.errors.add :Project, "Project does not exist"
      return false
    end
    Card.fetch(project_name)
  end

  def not_a_metric name
    card.errors.add :Metrics,
                    "Incorrect Metric name or Metric not available: "\
                   "#{name}"
    card.format.render_errors
  end

  def existing_metric? name
    (m = Card.quick_fetch(name)) && m.type_id == MetricID
  end

  def view_template_path view
    super(view, __FILE__)
  end

  def hr
    "<hr />"
  end

  def hidden_source_field
    if (source = Env.params[:source])
      hidden_field "hidden_source", value: source
    end
  end

  def company_field
    field_nest(:wikirate_company, title: "Company")
  end

  def metric_field
    metric_field = Card.fetch card.cardname.field(:metric),
                              new: { content: Env.params[:metric] }
    nest metric_field, title: "Metrics"
  end

  def next_button
    wrap_with :div, class: "col-md-6 col-centered text-center" do
      wrap_with :button, "Next", href: "#", class: "btn btn-primary", type: "submit"
    end
  end
end
