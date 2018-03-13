module Sundial
  class Schedule
    def initialize(business_hours = nil)
      @business_hours = business_hours
    end

    def elapsed(from, to)
      raise ArgumentError.new("The end time must be later than the start time.") if from > to

      Sundial::TimeDifference.new(self, TimeSegment.new(from, to))
    end
  end
end
