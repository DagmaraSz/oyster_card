require 'oystercard'

describe Oystercard do

	subject(:oystercard) { described_class.new }
	subject(:topped_up_oystercard) {described_class.new(10)}
	let(:station) { double(:station) }
	let(:journey) {double(:journey)}

  maximum_limit = Oystercard::MAXIMUM_LIMIT
  error1 = "The maximum balance you can have is £#{maximum_limit}!"
  minimum_amount = Oystercard::MINIMUM_AMOUNT

  def make_trip
    topped_up_oystercard.touch_in(station)
    topped_up_oystercard.touch_out(station)
  end

	it 'initializes with a balance of 0' do
		expect(oystercard.balance).to eq(0)
	end

	it 'tops up oystercard with given amount' do
		amount = rand(5..20) # can take various amounts
		oystercard.top_up(amount)
		expect(oystercard.balance).to eq(amount)
	end

	context 'Maximum Limit' do

		it 'has a maximum top up limit of £90' do
			expect(maximum_limit).to eq(90)
		end

		it 'allows balance to top up maximum of £90' do
			oystercard.top_up(60)
			expect { oystercard.top_up(31) }.to raise_error error1
			expect(oystercard.balance).to eq(60)
		end

	end

	context 'touch in and touch out' do
		before(:each) do
			topped_up_oystercard.touch_in(station)
		end

		context '#touch_in' do

			it 'has a minimum balance limit of £1' do
				expect(minimum_amount).to eq(1)
			end

			it "would start the journey" do
				expect(topped_up_oystercard.journey).to_not be nil
			end

			it 'would raise an error if balance is less than minimum amount' do
				expect { oystercard.touch_in(station) }.to raise_error 'Please top up more than £1!'
			end

		end

		context '#touch_out' do

			it 'would end the journey' do
				expect(topped_up_oystercard.journey).to receive(:finish)
				topped_up_oystercard.touch_out(station)
			end

			it 'deducts the journey fare' do
				allow(journey).to receive(:calculate_fare).and_return(1)
				expect {topped_up_oystercard.touch_out(station)}.to change{topped_up_oystercard.balance}.by(-1)
			end
		end
	end

  context 'incomplete journeys' do
  	it 'creates a new journey with nil entry station if journey does not exist' do
  		topped_up_oystercard.touch_out(station)
  		expect(topped_up_oystercard.journey.entry_station).to be nil
  	end

    it "deducts penalty if exit station wasn't logged" do
  		expect{
        2.times {topped_up_oystercard.touch_in(station)}
      }.to change{topped_up_oystercard.balance}.by(-Journey::PENALTY_FARE)
    end

    it 'at touch in logs the previous journey if it was incomplete' do
      2.times {topped_up_oystercard.touch_in(station)}
  		expect(topped_up_oystercard.journey_history[0]).to_not be nil
    end

    it "deducts penalty if entry station wasn't logged" do
      expect{
        topped_up_oystercard.touch_out(station)
        make_trip
      }.to change{topped_up_oystercard.balance}.by(-(Journey::PENALTY_FARE+Journey::MINIMUM_FARE))
    end

    it "doesn't double charge the user" do
      expect{
        3.times do
          make_trip
        end
      }.to change{topped_up_oystercard.balance}.by(-Journey::MINIMUM_FARE*3)
    end
  end

	context '#journey_history' do

		it 'is able to find the last entry station' do
			make_trip
			expect(topped_up_oystercard.journey_history[0].entry_station).to be(station)
		end

		it 'is able to find the last exit station' do
			make_trip
			expect(topped_up_oystercard.journey_history[0].exit_station).to be(station)
		end


		it 'has an empty journey history by default' do
			expect(topped_up_oystercard.journey_history).to eq([])
		end

	end

end
