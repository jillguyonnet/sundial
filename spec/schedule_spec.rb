RSpec.describe Sundial::Schedule do
  let(:business_hours) {
    {
      mon: {'09:00' => '17:00'},
      tue: {'09:00' => '17:00'},
      wed: {'09:00' => '17:00'},
      thu: {'09:00' => '17:00'},
      fri: {'09:00' => '12:00'}
    }
  }

  subject(:schedule) { described_class.new(business_hours) }

  describe '#elapsed' do
    context 'when the end time is earlier than the start time' do
      it 'raises an ArgumentError' do
        expect{ schedule.elapsed(Time.new(2018, 2, 15), Time.new(2018, 2, 14)) }.to raise_error(ArgumentError)
      end
    end

    context 'when both times are on the same day' do
      context 'and within business hours' do
        it 'returns the time_difference time' do
          from = Time.new(2018, 2, 14, 10, 0, 0)
          to   = Time.new(2018, 2, 14, 11, 2, 5)

          expect(schedule.elapsed(from, to)).to eq Sundial::Duration.new(1 * Sundial::TimeConstants::HOUR_SECONDS + 2 * Sundial::TimeConstants::MINUTE_SECONDS + 5)
        end
      end
    end
  end
end
