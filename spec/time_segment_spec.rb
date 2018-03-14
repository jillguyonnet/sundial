RSpec.describe Sundial::TimeSegment do
  let(:start_time) { Time.new(2018, 2, 14, 9) }
  let(:end_time)   { Time.new(2018, 2, 14, 17) }

  subject(:time_segment) { described_class.new(start_time, end_time) }

  describe '#initalize' do
    context 'when the end time is earlier than the start time' do
      it 'raises an ArgumentError' do
        expect{ described_class.new(Time.new(2018, 2, 15), Time.new(2018, 2, 14)) }.to raise_error(ArgumentError)
      end
    end
  end

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

  describe '#same_day?' do
    context 'when the start and end time are on the same day' do
      it 'returns true' do
        expect(time_segment.same_day?).to eq(true)
      end
    end

    context 'when the start and end time are not on the same day' do
      it 'returns false' do
        expect(described_class.new(start_time, Time.new(2018, 2, 15, 17)).same_day?).to eq(false)
      end
    end
  end

  describe '#full_days_between' do
    context 'when the start and end times are on the same day' do
      it 'returns an empty array' do
        from = Time.new(2018, 2, 14, 9)
        to   = Time.new(2018, 2, 14, 17)
        expect(described_class.new(from, to).full_days_between).to eq []
      end
    end

    context 'when the start and end times are consecutive' do
      it 'returns an empty array' do
        from = Time.new(2018, 2, 14, 9)
        to   = Time.new(2018, 2, 15, 17)
        expect(described_class.new(from, to).full_days_between).to eq []
      end
    end

    context 'when the start and end times are not consecutive' do
      it 'returns an array with the full days in between' do
        from = Time.new(2018, 2, 14, 9)
        to   = Time.new(2018, 2, 17, 17)
        expect(described_class.new(from, to).full_days_between).to eq [Time.new(2018, 2, 15), Time.new(2018, 2, 16)]
      end
    end
  end
end
