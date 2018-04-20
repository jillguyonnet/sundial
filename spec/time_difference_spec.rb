RSpec.describe Sundial::TimeDifference do
  let(:business_hours) {
    {
      mon: {'09:00' => '17:00'},
      tue: {'09:00' => '17:00'},
      wed: {'09:00' => '12:00', '13:00' => '17:00'},
      thu: {'09:00' => '20:00'},
      fri: {'09:00' => '12:00'}
    }
  }

  let(:configuration) {
    proc { |config| config.business_hours = business_hours }
  }

  let(:schedule) { Sundial::Schedule.new(&configuration) }

  subject(:time_difference) { described_class.new(schedule) }

  describe '#elapsed' do
    context 'when the end time is earlier than the start time' do
      it 'raises an ArgumentError' do
        expect{ time_difference.elapsed(Time.new(2018, 2, 15), Time.new(2018, 2, 14)) }.to raise_error(ArgumentError)
      end
    end

    context 'when the start and end times are identical' do
      it 'returns a zero duration' do
        expect(time_difference.elapsed(Time.new(2018, 2, 14, 9), Time.new(2018, 2, 14, 9))).to eq Sundial::Duration.new(0)
      end
    end

    context 'when the end time is later than the start time' do
      it 'returns the correct duration' do
        expect(time_difference.elapsed(Time.new(2018, 2, 14, 8), Time.new(2018, 2, 14, 19))).to eq Sundial::Duration.new(7 * Sundial::SECONDS_PER_HOUR)
        expect(time_difference.elapsed(Time.new(2018, 2, 14, 12, 5), Time.new(2018, 2, 14, 12, 55))).to eq Sundial::Duration.new(0)
        expect(time_difference.elapsed(Time.new(2018, 2, 16, 14), Time.new(2018, 2, 19, 10))).to eq Sundial::Duration.new(1 * Sundial::SECONDS_PER_HOUR)
      end
    end
  end
end
