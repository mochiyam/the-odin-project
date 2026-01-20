require './lib/drink.rb'

describe Drink do
  describe ":full" do
    it "will return if the drink is full" do
      drink = Drink.new
      expect(drink.full?).to eql(true) 
    end 
  end

  subject(:drink_tea) { described_class.new("tea", 16) }

  it "is tea" do
    expect(drink_tea.type).to eq("tea")
  end
end