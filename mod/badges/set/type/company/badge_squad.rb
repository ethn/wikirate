#! no set module

# all badges related to companies
class BadgeSquad
  extend Card::BadgeSquad

  add_badge_line :create,
                 company_register: 1,
                 the_company_store: 5,
                 companies_in_the_house: 25,
                 &create_type_count(:company)

  add_badge_line :logo,
                 logo_adder: 1,
                 how_lo_can_you_go: 10,
                 logo_and_behold: 100,
                 &type_plus_right_edited_count(:company, :image)
end
