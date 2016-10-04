require 'oystercard'

describe Oystercard do

	subject(:oystercard) { described_class.new }
	let(:entry_station) { double(:entry_station) }

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
			@minimum_fare = Oystercard::MINIMUM_FARE
			oystercard.top_up(5)
			oystercard.touch_in(entry_station)
		end

		it 'has a minimum balance limit of £1' do
			expect(@minimum_fare).to eq(1)
		end

		it "would start the journey" do
			expect(oystercard).to be_in_journey
		end

		it 'would end the journey' do
			oystercard.touch_out
			expect(oystercard).to_not be_in_journey
		end

		it 'would raise an error if balance is less than minimum amount' do
			oystercard2 = Oystercard.new
			expect { oystercard2.touch_in(entry_station) }.to raise_error 'Please top up more than £1!'
		end

		it 'deduct minimum fare £1' do
			expect {oystercard.touch_out}.to change{oystercard.balance}.by(-@minimum_fare)
		end

		it 'saves entry station' do
			expect(oystercard.entry_station).to eq(entry_station)
		end

		it "removes entry station" do
			oystercard.touch_out
			expect(oystercard.entry_station).to be_nil
		end

	end

end
