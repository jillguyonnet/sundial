RSpec.describe Sundial::Duration do
  subject(:duration) { described_class.new(18144) }

  describe 'in_seconds' do
    it 'returns the number of seconds' do
      expect(duration.in_seconds).to eq(18144)
    end
  end

  describe 'in_minutes' do
    it 'returns the number of minutes' do
      expect(duration.in_minutes).to eq(302)
    end
  end

  describe 'in_hours' do
    it 'returns the number of hours' do
      expect(duration.in_hours).to eq(5)
    end
  end

  context 'when performing comparison' do
    context 'and the compared object is a shorter duration' do
      let(:other) { described_class.new(300) }

      it 'compares as expected' do
        expect(duration > other).to eq true
      end
    end

    context 'and the compared object is the same duration' do
      let(:other) { described_class.new(18144) }

      it 'compares as expected' do
        expect(duration == other).to eq true
      end
    end

    context 'and the other object is a longer duration' do
      let(:other) { described_class.new(20000) }

      it 'compares as expected' do
        expect(duration < other).to eq true
      end
    end

    context 'and the compared object is not a duration' do
      let(:other) { 1 }

      it 'is not comparable' do
        expect { duration < other }.to raise_error ArgumentError
      end
    end
  end

  describe '#+' do
    let(:duration_1) { described_class.new(3600) }
    let(:duration_2) { described_class.new(300) }

    it 'adds the durations' do
      expect(duration_1 + duration_2).to eq described_class.new(3900)
    end
  end
end
