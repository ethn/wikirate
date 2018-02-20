def user_item_cards
  item_cards.select { |m| m.real? && m.type_id == UserID }.sort_by &:name
end

def ok_to_join?
  Auth.signed_in? && !current_user_is_member?
end

def current_user_is_member?
  item_cards.find { |item_card| item_card.id == Auth.current_id }
end

def joining?
  Env.params[:join].present?
end

event :join_group, :validate, when: :joining? do
  abort :failure, "cannot join this group" unless ok_to_join?
  add_item Auth.current.name
end

format :html do
  view :overview, tags: :unknown_ok do
    wrap do
      views :contributions, :join, :manage_button
    end
  end

  def views *views
    output { views.map { |view| render view }.join "\n" }
  end

  view :contributions, tags: :unknown_ok do
    table member_contribution_content,
          header: member_contribution_header
  end

  view :join, tags: :unknown_ok, denial: :blank, perms: ->(r) { r.card.ok_to_join? } do
    link_to "Join", path: { action: :update, join: true, success: { view: :overview } },
                    class: "btn btn-primary slotter", remote: true
  end

  view :manage_button, tags: :unknown_ok do
    link_to_view("edit", "Manage Researcher List", class:"btn slotter")
  end

  def member_contribution_header
    contribution_categories.map do |category|
      Card::Set::LtypeRtype::User::Cardtype::ACTION_LABELS[category]
    end.unshift "Answers"
  end

  def contribution_categories
    [:created, :updated, :discussed, :double_checked]
  end

  def member_contribution_content
    card.user_item_cards.map do |member|
      contribution_categories.map do |category|
        card.left.contribution_count member.name, :metric_value, category
      end.unshift nest(member, view: :thumbnail)
    end
  end
end