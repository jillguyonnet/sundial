RSpec.describe Sundial::Schedule do
  subject(:schedule) { described_class.new }

  describe '#elapsed' do
    context 'when t2 is earlier than t1' do
      it 'raises an ArgumentError' do
        from = Time.new(2018, 2, 14, 17)
        to   = Time.new(2018, 2, 14, 11)

        expect{ schedule.elapsed(from, to) }.to raise_error(ArgumentError)
      end
    end

    context 'when both times are on the same day' do
      context 'and within business hours' do
        it 'returns the elapsed time' do
          from = Time.new(2018, 2, 14, 10, 0, 0)
          to   = Time.new(2018, 2, 14, 11, 2, 5)

          expect(schedule.elapsed(from, to).in_seconds).to eq 1 * Sundial::TimeConstants::HOUR_SECONDS + 2 * Sundial::TimeConstants::MINUTE_SECONDS + 5
        end
      end

      context 'when it is not on a business day' do
        it 'returns zero' do
          from = Time.new(2018, 2, 25, 10, 0, 0)
          to   = Time.new(2018, 2, 25, 11, 2, 5)

          expect(schedule.elapsed(from, to).in_seconds).to eq 0
        end
      end

      context 'when t1 is outside business hours and t2 is inside business hours' do
        it 'returns the elapsed time from the beginning of the business hours' do
          from = Time.new(2018, 2, 14, 8)
          to   = Time.new(2018, 2, 14, 11)

          expect(schedule.elapsed(from, to).in_hours).to eq 2
        end
      end

      context 'when t1 is inside business hours and t2 is outside business hours' do
        it 'returns the elapsed time to the end of the business hours' do
          from = Time.new(2018, 2, 14, 11)
          to   = Time.new(2018, 2, 14, 19)

          expect(schedule.elapsed(from, to).in_hours).to eq 6
        end
      end
    end
  end
end
