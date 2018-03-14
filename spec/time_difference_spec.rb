RSpec.describe Sundial::TimeDifference do
  let(:business_hours) {
    {
      mon: {'09:00' => '17:00'},
      tue: {'09:00' => '17:00'},
      wed: {'09:00' => '17:00'},
      thu: {'09:00' => '17:00'},
      fri: {'09:00' => '12:00'}
    }
  }
  let(:schedule) { Sundial::Schedule.new(business_hours) }

  context 'when the start time is equal to the end time' do
    let(:from) { Time.new(2018, 02, 14) }
    let(:to)   { Time.new(2018, 02, 14) }
    let(:time_segment) { Sundial::TimeSegment.new(from, to) }

    it 'returns a zero duration' do
      expect(described_class.new(schedule, time_segment)).to eq Sundial::Duration.new(0)
    end
  end

  context 'when the start and end times are on the same day' do
    context 'when the start time is before business hours' do
      context 'when the end time is before business hours' do
      end

      context 'when the end time is within business hours' do
      end

      context 'when the end time is after business hours' do
      end
    end

    context 'when the start time is within business hours' do
      context 'when the end time is within business hours' do
        let(:from) { Time.new(2018, 02, 14, 10, 0, 0) } # 14 February 2018 is a Wednesday
        let(:to)   { Time.new(2018, 02, 14, 11, 2, 5) }
        let(:time_segment) { Sundial::TimeSegment.new(from, to) }

        it 'returns the time difference' do

          expect(described_class.new(schedule, time_segment)).to eq Sundial::Duration.new(1 * Sundial::HOUR_SECONDS + 2 * Sundial::MINUTE_SECONDS + 5)
        end
      end

      context 'when the end time is after business hours' do
      end
    end

    context 'when the start time is after business hours' do
    end
  end

  context 'when the start and end times are on two consecutive days' do
  end

  context 'when the start and end times are separated by at least one full day' do
  end
end
