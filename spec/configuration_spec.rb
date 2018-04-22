RSpec.describe Sundial::Configuration do
  let(:business_hours) {
    {
      mon: {'09:00' => '17:00'},
      tue: {'09:00' => '17:00'},
      wed: {'09:00' => '12:00', '13:00' => '17:00'},
      thu: {'09:00' => '20:00'},
      fri: {'09:00' => '12:00'}
    }
  }

  subject(:configuration) {
    Sundial::Configuration.new { |config|
      config.business_hours = business_hours
    }
  }

  context 'when initialized with an invalid configuration' do
    it 'raises an ArgumentError' do
      expect {
        Sundial::Configuration.new { |config|
          config.business_hours = 'foo'
        }
      }.to raise_error ArgumentError
    end
  end
end
