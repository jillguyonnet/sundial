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
    it 'returns the start time in epoch' do
      expect(time_segment.start_time).to eq(start_time.to_i)
    end
  end

  describe '#end_time' do
    it 'returns the end time in epoch' do
      expect(time_segment.end_time).to eq(end_time.to_i)
    end
  end

  describe '#&' do
    context 'when the other time segment occurs before' do
      let(:other) { described_class.new(Time.new(2018, 2, 13, 9), Time.new(2018, 2, 13, 17)) }

      it 'returns a zero-duration duration' do
        expect((time_segment & other).duration).to eq(Sundial::Duration.new(0))
      end
    end

    context 'when the other time segment starts before the start time' do
      context 'and ends between the start time and the end time' do
        let(:other) { described_class.new(Time.new(2018, 2, 14, 7), Time.new(2018, 2, 14, 12)) }

        it 'returns the correct time segment' do
          expect(time_segment & other).to eq(Sundial::TimeSegment.new(Time.new(2018, 2, 14, 9), Time.new(2018, 2, 14, 12)))
        end
      end

      context 'and ends after the end time' do
        let(:other) { described_class.new(Time.new(2018, 2, 14, 7), Time.new(2018, 2, 14, 19)) }

        it 'returns the correct time segment' do
          expect(time_segment & other).to eq(Sundial::TimeSegment.new(Time.new(2018, 2, 14, 9), Time.new(2018, 2, 14, 17)))
        end
      end
    end

    context 'when the other time segment starts after the start time' do
      context 'and ends before the end time' do
        let(:other) { described_class.new(Time.new(2018, 2, 14, 11), Time.new(2018, 2, 14, 12)) }

        it 'returns the correct time segment' do
          expect(time_segment & other).to eq(Sundial::TimeSegment.new(Time.new(2018, 2, 14, 11), Time.new(2018, 2, 14, 12)))
        end
      end

      context 'and ends after the end time' do
        let(:other) { described_class.new(Time.new(2018, 2, 14, 11), Time.new(2018, 2, 14, 19)) }

        it 'returns the correct time segment' do
          expect(time_segment & other).to eq(Sundial::TimeSegment.new(Time.new(2018, 2, 14, 11), Time.new(2018, 2, 14, 17)))
        end
      end
    end
  end

  context 'when performing comparison' do
    context 'and the compared object has an earlier start time' do
      let(:other) { described_class.new(Time.new(2018, 2, 14, 7), Time.new(2018, 2, 14, 17)) }

      it 'compares as expected' do
        expect(time_segment > other).to eq true
      end
    end

    context 'and the compared object has a later start time' do
      let(:other) { described_class.new(Time.new(2018, 2, 14, 11), Time.new(2018, 2, 14, 17)) }

      it 'compares as expected' do
        expect(time_segment > other).to eq false
      end
    end

    context 'and the compared object has an earlier end time' do
      let(:other) { described_class.new(Time.new(2018, 2, 14, 9), Time.new(2018, 2, 14, 15)) }

      it 'compares as expected' do
        expect(time_segment > other).to eq true
      end
    end

    context 'and the compared object has a later end time' do
      let(:other) { described_class.new(Time.new(2018, 2, 14, 9), Time.new(2018, 2, 14, 19)) }

      it 'compares as expected' do
        expect(time_segment < other).to eq true
      end
    end

    context 'and the compared object has the same endpoints' do
      let(:other) { described_class.new(Time.new(2018, 2, 14, 9), Time.new(2018, 2, 14, 17)) }

      it 'compares as expected' do
        expect(time_segment == other).to eq true
      end
    end

    context 'and the compared object is not a time_segment' do
      let(:other) { 1 }

      it 'is not comparable' do
        expect { time_segment < other }.to raise_error ArgumentError
      end
    end
  end

  describe '#include?' do
    context 'when the time is within the time segment' do
      it 'returns true' do
        expect(time_segment.include?(Time.new(2018, 2, 14, 13))).to eq(true)
      end
    end

    context 'when the time is before the time segment' do
      it 'returns false' do
        expect(time_segment.include?(Time.new(2018, 2, 14, 7))).to eq(false)
      end
    end

    context 'when the time is after the time segment' do
      it 'returns false' do
        expect(time_segment.include?(Time.new(2018, 2, 14, 19))).to eq(false)
      end
    end
  end
end
