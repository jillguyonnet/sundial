module Sundial
  class Schedule
    def elapsed(from, to)
      raise ArgumentError.new("The end time must be later than the start time.") if from > to

      Sundial::Calculator.new.time_difference(TimeSegment.new(from, to))
    end
  end
end
