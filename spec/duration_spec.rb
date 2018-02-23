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
end
