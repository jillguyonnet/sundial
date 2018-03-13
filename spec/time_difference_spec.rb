RSpec.describe Sundial::TimeDifference do
  let(:schedule) { Sundial::Schedule.new }

  subject(:time_difference) { described_class.new(schedule, time_segment) }

  context 'when the start time is equal to the end time' do
    let(:time_segment) { Sundial::TimeSegment.new(Time.new(2018, 02, 14), Time.new(2018, 02, 14)) }

    it 'returns a zero duration' do
      expect(time_difference).to eq Sundial::Duration.new(0)
    end
  end

  context 'when the start time is before the end time' do
    let(:time_segment) { Sundial::TimeSegment.new(Time.new(2018, 02, 14), Time.new(2018, 02, 15)) }

    it 'returns a zero duration' do
      expect(time_difference).to eq Sundial::Duration.new(86400)
    end
  end
end
