include_set Abstract::HardCodedFormula

def calculator_class
  Calculate::Isic
end

format :html do
  view :core do
    ["The first three digits of:", render_variable_metrics]
  end
end
