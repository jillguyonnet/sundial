RSpec.describe Sundial::Schedule do
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

  subject(:schedule) { described_class.new(&configuration) }

  describe '#in_business_hours?' do
    context 'when the day is not in the schedule' do
      it 'returns false' do
        expect(schedule.in_business_hours?(Time.new(2018, 2, 17, 10))).to eq false # 17 February 2018 is a Saturday
      end
    end

    context 'when the day is in the schedule' do
      context 'when the time is out of business hours' do
        it 'returns false' do
          expect(schedule.in_business_hours?(Time.new(2018, 2, 14, 8, 59, 59))).to eq false # 14 February 2018 is a Wednesday
          expect(schedule.in_business_hours?(Time.new(2018, 2, 14, 12, 0, 1))).to eq false
          expect(schedule.in_business_hours?(Time.new(2018, 2, 14, 17, 0, 1))).to eq false
        end
      end

      context 'when the time is in business hours' do
        it 'returns true' do
          expect(schedule.in_business_hours?(Time.new(2018, 2, 14, 10))).to eq true
          expect(schedule.in_business_hours?(Time.new(2018, 2, 14, 14))).to eq true
        end
      end
    end
  end

  describe '#business_hours_on_date' do
    context 'when the day is not in the schedule' do
      it 'returns an empty array' do
        expect(schedule.business_hours_on_date(Time.new(2018, 2, 17))).to eq({}) # 17 February 2018 is a Saturday
      end
    end

    context 'when the day is in the schedule' do
      it 'returns an array with the schedule of the day' do
        expect(schedule.business_hours_on_date(Time.new(2018, 2, 14))).to eq({'09:00' => '12:00', '13:00' => '17:00'}) # 17 February 2018 is a Saturday
      end
    end
  end

  describe '#time_segments_on_date' do
    context 'when the week day is not in the schedule' do
      it 'returns an empty array' do
        expect(schedule.time_segments_on_date(Date.new(2018, 2, 17))).to eq []
      end
    end

    context 'when the week day is in the schedule' do
      it 'returns an array with the corresponding time segments' do
        expect(schedule.time_segments_on_date(Date.new(2018, 2, 14))).to eq [Sundial::TimeSegment.new(Time.new(2018, 2, 14, 9), Time.new(2018, 2, 14, 12)), Sundial::TimeSegment.new(Time.new(2018, 2, 14, 13), Time.new(2018, 2, 14, 17))]
      end
    end
  end

  describe '#business_time_between' do
    context 'when the end time is earlier than the start time' do
      it 'raises an ArgumentError' do
        expect{ schedule.business_time_between(Time.new(2018, 2, 15), Time.new(2018, 2, 14)) }.to raise_error(ArgumentError)
      end
    end

    context 'when the start and end times are identical' do
      it 'returns a zero duration' do
        expect(schedule.business_time_between(Time.new(2018, 2, 14, 9), Time.new(2018, 2, 14, 9))).to eq Sundial::Duration.new(0)
      end
    end

    context 'when the end time is later than the start time' do
      it 'returns the correct duration' do
        expect(schedule.business_time_between(Time.new(2018, 2, 14, 8), Time.new(2018, 2, 14, 19))).to eq Sundial::Duration.new(7 * Sundial::SECONDS_PER_HOUR)
        expect(schedule.business_time_between(Time.new(2018, 2, 14, 12, 5), Time.new(2018, 2, 14, 12, 55))).to eq Sundial::Duration.new(0)
        expect(schedule.business_time_between(Time.new(2018, 2, 16, 14), Time.new(2018, 2, 19, 10))).to eq Sundial::Duration.new(1 * Sundial::SECONDS_PER_HOUR)
      end
    end
  end
end
