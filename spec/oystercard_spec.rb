require 'oystercard'

describe Oystercard do

  before do
    @top_up_value = 10
    @deduct_value = 5
  end

  let (:station) {double "Station"}

  it "expect new card to have a 0 balance" do
    expect(subject.balance).to eq 0
  end

  it "should reflect top-up value in balance" do
    subject.top_up(@top_up_value)
    expect(subject.balance).to eq @top_up_value
  end

  it "should raise an error if top-up will cause balance to exceed limit" do
    expect {subject.top_up(Oystercard::CAPACITY+1)}.to raise_error "Limit of £#{Oystercard::CAPACITY} exceeded"
  end

  it "should return in_journey status" do
    subject.in_journey?.should be false
  end

  it "should change in_journey status on touch in" do
    subject.top_up(@top_up_value)
    subject.touch_in(station)
    subject.in_journey?.should be true
  end

  it "should change in_journey status on touch out" do
    subject.top_up(@top_up_value)
    subject.touch_in(station)
    subject.touch_out
    subject.in_journey?.should be false
  end

  it "should raise an error if minimum value is not met" do
    expect {subject.touch_in(station)}.to raise_error "insufficient funds to complete journey"
  end

  it 'should deduct the minimum fare from the balance on touch out' do
    subject.top_up(@top_up_value)
    subject.touch_in(station)
    expect {subject.touch_out}.to change{subject.balance}.by(0 - Oystercard::MINIMUM_FARE)
  end

  it 'should remember entry station' do
    subject.top_up(@top_up_value)
    subject.touch_in(station)
    expect(subject.entry_station).to eq station
  end

  it 'should forget entry station on touch out' do
    subject.top_up(@top_up_value)
    subject.touch_in(station)
    subject.touch_out
    expect(subject.entry_station).to eq nil
  end

  it "tests" do
    
  end

end
