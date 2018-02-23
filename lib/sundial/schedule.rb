module Sundial
  class Schedule
    def elapsed(from, to)
      Sundial::Duration.new(Integer(to - from)).in_seconds
    end
  end
end
