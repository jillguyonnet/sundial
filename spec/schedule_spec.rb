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
  end

  describe '#total_business_time_on_day' do
    context 'when the day is present in the business hours config' do
      it 'returns the total business time' do
        wednesday = Time.new(2018, 2, 14)
        expect(schedule.total_business_time_on_day(wednesday)).to eq Sundial::Duration.new(28800)
      end
    end

    context 'when the day is not present in the business hours config' do
      it 'returns a zero duration' do
        sunday = Time.new(2018, 2, 18)
        expect(schedule.total_business_time_on_day(sunday)).to eq Sundial::Duration.new(0)
      end
    end
  end

  describe '#business_time_on_day_before' do
    context 'when the time is within business hours' do
      it 'returns the business time before that time' do
        expect(schedule.business_time_on_day_before(Time.new(2018, 2, 14, 11, 30))).to eq Sundial::Duration.new(9000)
      end
    end

    context 'when the time is not on a business day' do
      it 'returns a zero duration' do
        expect(schedule.business_time_on_day_before(Time.new(2018, 2, 17, 11, 30))).to eq Sundial::Duration.new(0)
      end
    end

    context 'when the time is before business hours' do
      it 'returns a zero duration' do
        expect(schedule.business_time_on_day_before(Time.new(2018, 2, 14, 8))).to eq Sundial::Duration.new(0)
      end
    end

    context 'when the time is after business hours' do
      it 'returns the total business time' do
        wednesday = Time.new(2018, 2, 14, 18)
        expect(schedule.business_time_on_day_before(wednesday)).to eq schedule.total_business_time_on_day(wednesday)
      end
    end
  end

  describe '#business_time_on_day_after' do
    context 'when the time is within business hours' do
      it 'returns the business time before that time' do
        expect(schedule.business_time_on_day_after(Time.new(2018, 2, 14, 11, 30))).to eq Sundial::Duration.new(19800)
      end
    end

    context 'when the time is not on a business day' do
      it 'returns a zero duration' do
        expect(schedule.business_time_on_day_after(Time.new(2018, 2, 17, 11, 30))).to eq Sundial::Duration.new(0)
      end
    end

    context 'when the time is before business hours' do
      it 'returns the total business time' do
        wednesday = Time.new(2018, 2, 14, 8)
        expect(schedule.business_time_on_day_after(wednesday)).to eq schedule.total_business_time_on_day(wednesday)
      end
    end

    context 'when the time is after business hours' do
      it 'returns a zero duration' do
        expect(schedule.business_time_on_day_after(Time.new(2018, 2, 14, 18))).to eq Sundial::Duration.new(0)
      end
    end
  end

  describe '#business_time_on_day' do
    context 'when two different days are passed as arguments' do
      it 'raises an ArgumentError' do
        expect{ schedule.business_time_on_day(Time.new(2018, 2, 15), Time.new(2018, 2, 14)) }.to raise_error(ArgumentError)
      end
    end

    context 'when the end time is earlier than the start time' do
      it 'raises an ArgumentError' do
        expect{ schedule.business_time_on_day(Time.new(2018, 2, 15), Time.new(2018, 2, 14)) }.to raise_error(ArgumentError)
      end
    end

    context 'when the start time is before business hours' do
      context 'when the end time is before business hours' do
        it 'returns a zero duration' do
          expect(schedule.business_time_on_day(Time.new(2018, 2, 14, 7), Time.new(2018, 2, 14, 7))).to eq Sundial::Duration.new(0)
        end
      end

      context 'when the end time is within business hours' do
        it 'returns the business time before the end time' do
          from = Time.new(2018, 2, 14, 7)
          to   = Time.new(2018, 2, 14, 11)
          expect(schedule.business_time_on_day(from, to)).to eq schedule.business_time_on_day_before(to)
        end
      end

      context 'when the end time is after business hours' do
        it 'returns the total business time' do
          from = Time.new(2018, 2, 14, 7)
          to   = Time.new(2018, 2, 14, 18)
          expect(schedule.business_time_on_day(from, to)).to eq schedule.total_business_time_on_day(from)
        end
      end
    end

    context 'when the start time is within business hours' do
      context 'when the end time is within business hours' do
        it 'returns the business time between the start and the end times' do
          from = Time.new(2018, 2, 14, 11)
          to   = Time.new(2018, 2, 14, 14)
          expect(schedule.business_time_on_day(from, to)).to eq Sundial::Duration.new(10800)
        end
      end

      context 'when the end time is after business hours' do
        it 'returns the business time after the start time' do
          from = Time.new(2018, 2, 14, 11)
          to   = Time.new(2018, 2, 14, 18)
          expect(schedule.business_time_on_day(from, to)).to eq schedule.business_time_on_day_after(from)
        end
      end
    end

    context 'when the start time is after business hours' do
      it 'returns a zero duration' do
        from = Time.new(2018, 2, 14, 18)
        to   = Time.new(2018, 2, 14, 19)
        expect(schedule.business_time_on_day(from, to)).to eq Sundial::Duration.new(0)
      end
    end
  end
end
