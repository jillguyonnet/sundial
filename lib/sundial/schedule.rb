module Sundial
  class Schedule
    def elapsed(from, to)
      Sundial::Duration.new(Integer(to - from))
    end
  end
end
