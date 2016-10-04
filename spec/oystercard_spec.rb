require 'oystercard'

describe Oystercard do

	subject(:oystercard) { described_class.new }

	

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

	it "deducts given amount from balance" do
		oystercard.top_up(40)
		oystercard.deduct(20)
		expect(oystercard.balance).to eq 20
	end

	context 'touch in and touch out' do

		it 'has a minimum balance limit of £1' do
			expect(Oystercard::MINIMUM_AMOUNT).to eq(1)
		end

		it "would start the journey" do
			oystercard.top_up(5)
			oystercard.touch_in
			expect(oystercard).to be_in_journey
		end

		it 'would end the journey' do
			oystercard.top_up(5)
			oystercard.touch_in
			oystercard.touch_out
			expect(oystercard).to_not be_in_journey
		end

		it 'would raise an error if balance is less than minimum amount' do
			oystercard.top_up(0.5)
			expect { oystercard.touch_in }.to raise_error 'Please top up more than £1!'
		end

	end

end
