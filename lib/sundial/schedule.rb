module Sundial
  class Schedule
    def initialize(business_hours)
      @business_hours = business_hours
      @time_difference_calculator = Sundial::TimeDifference.new(self)
    end

    attr_reader :business_hours

    def in_business_hours?(t)
      return false unless business_hours.keys.include?(Sundial::WEEK_DAYS[t.wday])

      business_hours_start = Time.new(t.year, t.month, t.day, business_hours[Sundial::WEEK_DAYS[t.wday]][0].to_i)
      business_hours_end = Time.new(t.year, t.month, t.day, business_hours[Sundial::WEEK_DAYS[t.wday]][1].to_i)

      t >= business_hours_start && t <= business_hours_end
    end

    def business_hours_on_day(t)
      return [] unless business_hours.keys.include?(Sundial::WEEK_DAYS[t.wday])

      [business_hours[Sundial::WEEK_DAYS[t.wday]][0], business_hours[Sundial::WEEK_DAYS[t.wday]][1]]
    end

    def elapsed(from, to)
      raise ArgumentError.new("The end time must be later than the start time.") if from > to

      @time_difference_calculator.elapsed(from, to)
    end
  end
end
