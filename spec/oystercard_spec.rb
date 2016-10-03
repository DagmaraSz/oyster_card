require 'oystercard'

describe Oystercard do
  subject(:card) {described_class.new}

  it "has a balance of 0 to start with" do
    expect(card.balance).to eq(0)
  end

  it "can be topped up" do
    card.top_up(5)
    expect(card.balance).to eq 5
  end

  it "has a max balance of 90" do
    expect{card.top_up(91)}.to raise_error("Card limit (£#{Oystercard::MAX_BALANCE}) reached")
  end

  it "money can be decuted from the card" do
    card.top_up(5)
    card.deduct(3)
    expect(card.balance).to eq 2
  end
end
