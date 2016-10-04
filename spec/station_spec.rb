require 'station'

describe Station do

  subject(:station) {described_class.new("Liverpool Street", 1)}
  subject(:station2) {described_class.new("Bank", 2)}

  it 'returns zone' do
    expect(station.zone).to eq(1)
  end

  it 'returns zone' do
    expect(station2.zone).to eq(2)
  end

  it 'returns name' do
    expect(station.name).to eq("Liverpool Street")
  end

  it 'returns name' do
    expect(station2.name).to eq("Bank")
  end

end
