require 'journey'

describe Journey do

	subject(:journey) {described_class.new}
	let(:station) { double(:station) }

	it {is_expected.to respond_to(:start)}
	it {is_expected.to respond_to(:finish)}
	it {is_expected.to respond_to(:calculate_fare)}
	it {is_expected.to have_attributes(entry_station: nil)}

	it 'completes when started and finished' do
		journey.start(station)
		journey.finish(station)
		expect(journey).to be_complete
	end

	context '#start' do

		it 'sets an entry station', focus: :true do
			journey.start(station)
			expect(journey.entry_station).to eq(station)
		end
	end

	context '#finish' do

		it 'sets an exit station' do
			journey.finish(station)
			expect(journey.exit_station).to eq(station)
		end

	end

	context '#calculate_fare' do

		it 'returns minimum fare if journey is complete' do
			journey.start(station)
			journey.finish(station)
			expect(journey.calculate_fare).to eq(Journey::MINIMUM_FARE)
		end

		it 'returns penalty fare if journey is not started' do
			journey.finish(station)
			expect(journey.calculate_fare).to eq(Journey::PENALTY_FARE)
		end

		it 'returns penalty fare if journey is not finished' do
			journey.start(station)
			expect(journey.calculate_fare).to eq(Journey::PENALTY_FARE)
		end
	end
	
end