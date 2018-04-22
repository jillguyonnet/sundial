RSpec.describe Sundial::Validation do
  let(:configuration) { Struct.new(:business_hours).new }

  subject(:validation) { described_class.new(configuration) }

  describe '#perform' do
    context 'when the business hours are hash-like' do
      context 'when all the keys are valid' do
        before { configuration.business_hours = {mon: {'09:00' => '17:00'}} }

        it 'does not raise an error' do
          expect { validation.perform }.not_to raise_error
        end
      end

      context 'when there is at least one invalid key' do
        before { configuration.business_hours = {foo: {'09:00' => '17:00'}} }

        it 'raises an ArgumentError' do
          expect { validation.perform }.to raise_error ArgumentError
        end
      end
    end

    context 'when the business hours are not hash-like' do
      before { configuration.business_hours = 'foo' }

      it 'raises an ArgumentError' do
        expect { validation.perform }.to raise_error ArgumentError
      end
    end
  end
end
