module Sundial
  class Duration

    include Comparable

    attr_reader :seconds

    def initialize(seconds)
      @seconds = seconds
    end

    def in_seconds
      seconds
    end

    def in_minutes
      seconds / 60
    end

    def in_hours
      seconds / 3600
    end

    def <=>(other)
      return unless other.is_a?(self.class)

      seconds <=> other.seconds
    end

    def +(other)
      self.class.new(seconds + other.seconds)
    end
  end
end
