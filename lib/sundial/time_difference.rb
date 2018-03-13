module Sundial
  class TimeDifference < SimpleDelegator
    def initialize(schedule, time_segment)
      super(time_segment.duration)
    end
  end
end
