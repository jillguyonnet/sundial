RSpec.describe Sundial do
  it 'has a version number' do
    expect(Sundial::VERSION).not_to be nil
  end

  context 'when configured' do
    before { described_class.configure { |config|
      config.business_hours = {wed: {'9:00' => '17:00'}}
    } }

    describe '.in_business_hours?' do
      it 'delegates to the schedule' do
        expect(described_class.in_business_hours?(Time.new(2018, 2, 14, 10))).to eq true
        expect(described_class.in_business_hours?(Time.new(2018, 2, 14, 18))).to eq false
      end
    end

    describe '.business_hours_on_date' do
      it 'delegates to the schedule' do
        expect(described_class.business_hours_on_date(Time.new(2018, 2, 17))).to eq({})
        expect(described_class.business_hours_on_date(Time.new(2018, 2, 14))).to eq({'9:00' => '17:00'})
      end
    end

    describe '.elapsed' do
      it 'delegates to the schedule' do
        expect(described_class.elapsed(Time.new(2018, 2, 14, 9), Time.new(2018, 2, 14, 9))).to eq Sundial::Duration.new(0)
        expect(described_class.elapsed(Time.new(2018, 2, 14, 7), Time.new(2018, 2, 14, 19))).to eq Sundial::Duration.new(8 * Sundial::SECONDS_PER_HOUR)
      end
    end
  end

  context 'when not configured' do
    before { described_class.schedule = nil }

    describe 'when schedule methods are called' do
      it 'raises a RuntimeError' do
        expect{described_class.in_business_hours?(Time.new(2018, 2, 14, 10))}.to raise_error('No schedule configured')
      end
    end
  end
end
