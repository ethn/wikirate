RSpec.describe Card::Set::Right::ImportMap do
  def card_subject
    @card_subject ||= Card["answer import test"].import_map_card
  end

  check_views_for_errors :core, :bar

  describe "#map" do
    it "contains a key for each mapped column" do
      expect(card_subject.map.keys).to eq(AnswerImportItem.mapped_column_keys)
    end

    it "maps existing names to ids" do
      name = "Jedi+disturbances in the Force".to_name
      expect(card_subject.map[:metric][name]).to eq(name.card_id)
    end

    it "maps non-existing names to nil" do
      expect(card_subject.map[:metric])
        .to include("Not a metric" => nil)
    end

    it "handles blank content" do
      card_subject.content = ""
      expect(card_subject.map).to be_a(Hash)
    end
  end

  describe "#auto_map!" do
    it "creates a map based on auto matching" do
      initial_content = card_subject.content
      puts initial_content
      puts card_subject.auto_map!
      expect(card_subject.auto_map!).to eq(initial_content)
    end
  end

  describe "event: update_import_mapping" do
    def with_mapping_param value
      Card::Env.params[:mapping] = value
      yield
    end

    it "updates map based on 'mapping' parameter" do
      with_mapping_param wikirate_company: { "Google" => "Google LLC" } do
        card_subject.update!({})
        expect(card_subject.map[:wikirate_company]["Google"])
          .to eq("Google LLC".to_name.card_id)
      end
    end
  end

  describe "format#tab_title" do
    it "gives counts for total and unmapped values" do
      expect(format_subject.tab_title(:metric))
        .to have_tag("div.tab-title") do
          with_tag "span.count-number" do
            with_tag "div.tab-badge" do
              with_tag("span.badge") { 2 }
              with_tag "span.badge-label" do
                with_tag "i.fa-bar-chart"
              end
            end
          end
          with_tag "span.count-label" do
            "(1) Metrics"
          end
        end
    end
  end
end
