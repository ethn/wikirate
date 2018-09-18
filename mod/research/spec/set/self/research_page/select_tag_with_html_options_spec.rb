# -*- encoding : utf-8 -*-

RSpec.describe Card::Set::Self::ResearchPage::SelectTagWithHtmlOptions do
  subject do
    tag = described_class.new(:fruit, Card["A"].format,
                              url: ->(item) { "/#{item}" },
                              option_template: ->(item) { "<small>#{item}</small>" },
                              selected_option_template: ->(item) { "<h1>#{item}</h1>" })
    tag.render([:apple, :orange], selected: :orange)
  end

  it "has select tag" do
    expect(subject).to have_tag "select._html-select._no-select2#fruit-html-select" do
      with_tag :option, with: { value: 0,
                                "data-option-selector": "#fruit-option-0",
                                "data-selected-option-selector": "#fruit-selected-option-0",
                                "data-url": "/apple" },
                        text: "apple"
      with_tag :option, with: { value: 1, selected: "selected" }, text: "orange"
    end
  end

  it "has options markup" do
    expect(subject).to have_tag "div#fruit-select-options" do
      with_tag "div#fruit-option-0" do
        with_tag :small, "apple"
      end
      with_tag "div#fruit-option-1" do
        with_tag :small, "orange"
      end
    end
  end

  it "has selected options markup" do
    expect(subject).to have_tag "div#fruit-select-options" do
      with_tag "div#fruit-selected-option-0" do
        with_tag :h1, "apple"
      end
      with_tag "div#fruit-selected-option-1" do
        with_tag :h1, "orange"
      end
    end
  end
end
