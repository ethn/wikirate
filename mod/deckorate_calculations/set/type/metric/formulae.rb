# NOTE: it would be nice to have these accessors in Abstract::Calculation, but
# if there they don't properly set the default cardtype for the fields

card_accessor :formula, type: :phrase # not needed by descendants or wikiratings
card_accessor :variables, type: :json # not needed by scores


def formula_editor
  :standard_formula_editor
end

def hidden_content_in_formula_editor?
  false
end

def formula_core
  :standard_formula_core
end

# </OVERRIDES>


# special method used in the context of a wikirating

format :html do
  # TODO: hamlize
  def weight_row weight=0, label=nil
    haml :weight_row, weight: weight, label: (label || render_thumbnail_no_link)
  end
end
