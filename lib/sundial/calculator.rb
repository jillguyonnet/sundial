module Sundial
  class Calculator
    def time_difference(from, to)
      if same_day?(from, to)
        return Sundial::Duration.new(Integer(to_previous_business_hour(to) - to_next_business_hour(from))) unless weekend?(from)
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

    def to_next_business_hour(t)
      if t.hour < 9
        Time.new(t.year, t.month, t.day, 9)
      else
        t
      end
    end

    def to_previous_business_hour(t)
      if t.hour > 17
        Time.new(t.year, t.month, t.day, 17)
      else
        t
      end
    end
  end
end
