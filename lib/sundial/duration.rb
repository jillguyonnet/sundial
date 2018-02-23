module Sundial
  class Duration
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
  end
end
