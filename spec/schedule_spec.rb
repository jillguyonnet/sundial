RSpec.describe Sundial::Schedule do
  subject(:schedule) { described_class.new }

  describe '#elapsed' do
    context 'when both times are on the same day' do
      context 'when it is on a business day' do
        it 'returns the elapsed time' do
          from = Time.new(2018, 2, 14, 10, 0, 0)
          to   = Time.new(2018, 2, 14, 11, 2, 5)

          expect(schedule.elapsed(from, to).in_seconds).to eq 1 * Sundial::Time::HOUR_SECONDS + 2 * Sundial::Time::MINUTE_SECONDS + 5
        end
      end

      context 'when it is not on a business day' do
        it 'returns zero' do
          from = Time.new(2018, 2, 25, 10, 0, 0)
          to   = Time.new(2018, 2, 25, 11, 2, 5)

          expect(schedule.elapsed(from, to).in_seconds).to eq 0
        end
      end
    end
  end
end