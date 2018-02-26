RSpec.describe Sundial::Schedule do
  subject(:schedule) { described_class.new }

  describe '#elapsed' do
    describe 'when both times are within the same business day' do
      it 'returns the elapsed time' do
        from = Time.new(2018, 2, 14, 10, 0, 0)
        to   = Time.new(2018, 2, 14, 11, 2, 5)
        expect(schedule.elapsed(from, to).in_seconds).to eq 3600 + 2 * 60 + 5
      end
    end
  end
end
