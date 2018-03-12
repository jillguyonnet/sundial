RSpec.describe Sundial::Schedule do
  subject(:schedule) { described_class.new }

  describe '#elapsed' do
    it 'returns a Sundial::Duration object' do
      expect(schedule.elapsed(Time.new(2018, 2, 14), Time.new(2018, 2, 15))).to be_a Sundial::Duration
    end

    context 'when the end time is earlier than the start time' do
      it 'raises an ArgumentError' do
        expect{ schedule.elapsed(Time.new(2018, 2, 15), Time.new(2018, 2, 14)) }.to raise_error(ArgumentError)
      end
    end
  end
end
