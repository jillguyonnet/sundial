RSpec.describe Sundial::Schedule do
  let(:business_hours) {
    {
      mon: ['09:00', '17:00'],
      tue: ['09:00', '17:00'],
      wed: ['09:00', '17:00'],
      thu: ['09:00', '17:00'],
      fri: ['09:00', '17:00']
    }
  }

  subject(:schedule) { described_class.new(business_hours) }

  describe '#in_business_hours?' do
    context 'when the day is not in the schedule' do
      it 'returns false' do
        expect(schedule.in_business_hours?(Time.new(2018, 2, 17, 10))).to eq(false) # 17 February 2018 is a Saturday
      end
    end

    context 'when the day is in the schedule' do
      context 'when the time is out of business hours' do
        it 'returns false' do
          expect(schedule.in_business_hours?(Time.new(2018, 2, 14, 8, 59, 59))).to eq(false) # 14 February 2018 is a Wednesday
          expect(schedule.in_business_hours?(Time.new(2018, 2, 14, 17, 0, 1))).to eq(false)
        end
      end

      context 'when the time is in business hours' do
        it 'returns true' do
          expect(schedule.in_business_hours?(Time.new(2018, 2, 14, 10))).to eq(true)
        end
      end
    end
  end

  describe '#business_hours_on_day' do
    context 'when the day is not in the schedule' do
      it 'returns an empty array' do
        expect(schedule.business_hours_on_day(Time.new(2018, 2, 17))).to eq([]) # 17 February 2018 is a Saturday
      end
    end

    context 'when the day is in the schedule' do
      it 'returns an array with the schedule of the day' do
        expect(schedule.business_hours_on_day(Time.new(2018, 2, 14))).to eq(['09:00', '17:00']) # 17 February 2018 is a Saturday
      end
    end
  end

  describe '#elapsed' do
    context 'when the end time is earlier than the start time' do
      it 'raises an ArgumentError' do
        expect{ schedule.elapsed(Time.new(2018, 2, 15), Time.new(2018, 2, 14)) }.to raise_error(ArgumentError)
      end
    end

    context 'when the start and end time are on the same business day' do
      it 'returns the correct duration' do
        expect(schedule.elapsed(Time.new(2018, 2, 14, 7), Time.new(2018, 2, 14, 10))).to eq Sundial::Duration.new(1 * Sundial::SECONDS_PER_HOUR)
        expect(schedule.elapsed(Time.new(2018, 2, 14, 9), Time.new(2018, 2, 14, 20))).to eq Sundial::Duration.new(8 * Sundial::SECONDS_PER_HOUR)
      end
    end

    context 'when the start and end time are on consecutive business days' do
      it 'returns the correct duration' do
        expect(schedule.elapsed(Time.new(2018, 2, 14, 10), Time.new(2018, 2, 15, 13))).to eq Sundial::Duration.new(11 * Sundial::SECONDS_PER_HOUR)
        expect(schedule.elapsed(Time.new(2018, 2, 14, 19), Time.new(2018, 2, 15, 10))).to eq Sundial::Duration.new(1 * Sundial::SECONDS_PER_HOUR)
      end
    end

    context 'when there are non business days between the start and end time' do
      it 'returns the correct duration' do
        expect(schedule.elapsed(Time.new(2018, 2, 16, 12), Time.new(2018, 2, 19, 9))).to eq Sundial::Duration.new(5 * Sundial::SECONDS_PER_HOUR)
      end
    end
  end
end
