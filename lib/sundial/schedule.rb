module Sundial
  class Schedule
    def initialize(business_hours)
      @business_hours = business_hours
      @time_difference_calculator = Sundial::TimeDifference.new(self)
    end

    attr_reader :business_hours

    def elapsed(from, to)
      raise ArgumentError.new("The end time must be later than the start time.") if from > to

      @time_difference_calculator.elapsed(from, to)
    end
  end
end
