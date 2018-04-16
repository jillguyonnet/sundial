module Sundial
  class TimeSegment

    include Comparable

    def initialize(start_time, end_time)
      @start_time = start_time.to_i # Time#to_i returns the epoch in seconds
      @end_time   = end_time.to_i
    end

    attr_reader :start_time, :end_time

    def duration
      Sundial::Duration.new(end_time - start_time)
    end

    def &(other)
      lower_bound = [self, other].map(&:start_time).max
      upper_bound = [self, other].map(&:end_time).min

      self.class.new(lower_bound, [lower_bound, upper_bound].max)
    end

    def <=>(other)
      return unless other.is_a?(self.class)

      [start_time, end_time] <=> [other.start_time, other.end_time]
    end
  end
end
