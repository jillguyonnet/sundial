RSpec.describe Sundial::TimeSegment do
  let(:start_time) { Time.new(2018, 2, 14, 9) }
  let(:end_time)   { Time.new(2018, 2, 14, 17) }

  subject(:time_segment) { described_class.new(start_time, end_time) }

  describe '#duration' do
    it 'returns a Sundial::Duration object' do
      expect(time_segment.duration).to be_a Sundial::Duration
    end

    it 'returns the duration of the time segment' do
      expect(time_segment.duration.in_hours).to eq(8)
    end
  end

  describe '#start_time' do
    it 'returns the start time' do
      expect(time_segment.start_time).to eq(start_time)
    end
  end

  describe '#end_time' do
    it 'returns the end time' do
      expect(time_segment.end_time).to eq(end_time)
    end
  end
end
