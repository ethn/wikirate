# -*- encoding : utf-8 -*-

class NewHomepageCodenames < Card::Migration
  def up
    ensure_card "homepage numbers", codename: "homepage_numbers"
    ensure_card "homepage projects", codename: "homepage_projects"
    ensure_card "homepage topics", codename: "homepage_topics"
    ensure_card "homepage organizations", codename: "homepage_organizations"
    ensure_card "homepage video section", codename: "homepage_video_section"
    ensure_card "homepage footer", codename: "homepage_footer"
    ensure_card "homepage featured companies", codename: "homepage_featured_companies"
    ensure_card "homepage featured projects", codename: "homepage_featured_projects"
    ensure_card "homepage featured topics", codename: "homepage_featured_projects"
    ensure_card "homepage adjectives", codename: "homepage_adjectives"
    ensure_card "script: wodry", codename: "script_wodry", type_id: Card::JavaScriptID
    ensure_card "style: wodry", codename: "style_wodry", type_id: Card::CssID
    Card::Cache.reset_all
  end
end
