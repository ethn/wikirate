RSpec.describe Card::Set::Self::Record do
  def self.answer year
    "Joe User+big single+Sony_Corporation+#{year}"
  end

  describe "created query" do
    include_context "report query", :record, :created
    variants checked_by_others: answer(2004),
             updated_by_others: [answer(2009)],
             discussed_by_others: answer(2006),
             all: 7
  end

  describe "updated query" do
    include_context "report query", :record, :updated
    variants all: [answer(2008), answer(2010)]
  end

  describe "discussed query" do
    include_context "report query", :record, :discussed
    variants all: answer(2007)
  end
end