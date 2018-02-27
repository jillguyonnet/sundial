module Sundial
  class Schedule
    def elapsed(from, to)
      if same_day?(from, to)
        return Sundial::Duration.new(Integer(to - from)) unless weekend?(from)
      end

      Sundial::Duration.new(0)
    end

    private

    def same_day?(t1, t2)
      t1.year === t2.year && t1.month === t2.month && t1.day === t2.day
    end

    def weekend?(t)
      t.saturday? || t.sunday?
    end
  end
end
