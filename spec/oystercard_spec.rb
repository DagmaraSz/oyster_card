require 'oystercard'

describe Oystercard do

	subject(:oystercard) { described_class.new }
	subject(:oystercard2) { described_class.new }
	let(:entry_station)  { double(:station) }
	let(:exit_station)   { double(:station)}
	let(:journey)				 {double(:journey)}

	before (:each) do
		@minimum_amount = Oystercard::MINIMUM_AMOUNT
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

		before(:each) do
			@maximum_limit = Oystercard::MAXIMUM_LIMIT
			@error1 = "The maximum balance you can have is £#{@maximum_limit}!"
		end

		it 'has a maximum top up limit of £90' do
			expect(@maximum_limit).to eq(90)
		end

		it 'allows balance to top up maximum of £90' do
			oystercard.top_up(60)
			expect { oystercard.top_up(31) }.to raise_error @error1
			expect(oystercard.balance).to eq(60)
		end

	end

	context 'touch in and touch out' do
		before(:each) do
			oystercard.top_up(5)
			oystercard.touch_in(entry_station)
		end

		context '#touch_in' do

			it 'has a minimum balance limit of £1' do
				expect(@minimum_amount).to eq(1)
			end

			it "would start the journey" do
				expect(oystercard.journey).to_not be nil
			end

			it 'would raise an error if balance is less than minimum amount' do
				expect { oystercard2.touch_in(entry_station) }.to raise_error 'Please top up more than £1!'
			end

		end



		context '#touch_out' do

			it 'would end the journey' do
				expect(oystercard.journey).to receive(:finish)
				oystercard.touch_out(exit_station)
			end

			it 'deducts the journey fare' do
				allow(journey).to receive(:calculate_fare).and_return(1)
				expect {oystercard.touch_out(exit_station)}.to change{oystercard.balance}.by(-1)
			end

		end

	end


	it 'creates a new journey with nil entry station if journey does not exist' do
		oystercard.touch_out(entry_station)
		expect(oystercard.journey.entry_station).to be nil		
	end

	context '#journey_history' do

		it 'is able to find the last entry station' do
			oystercard.top_up(5)
			oystercard.touch_in(entry_station)
			oystercard.touch_out(exit_station)
			expect(oystercard.journey_history[0].entry_station).to be(entry_station)
		end

		it 'is able to find the last exit station' do
			oystercard.top_up(5)
			oystercard.touch_in(entry_station)
			oystercard.touch_out(exit_station)
			expect(oystercard.journey_history[0].exit_station).to be(exit_station)
		end


		it 'has an empty journey history by default' do
			expect(oystercard.journey_history).to eq([])
		end

	end

end
