module Sundial
  class TimeSegment
    def initialize(start_time, end_time)
      @start_time = start_time
      @end_time   = end_time
    end

    attr_reader :start_time, :end_time

    def duration
      Duration.new(end_time - start_time)
    end
  end
end
