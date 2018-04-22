module Sundial
  class Schedule
    def initialize(&config)
      @configuration = Configuration.new(&config)
      @time_difference_calculator = TimeDifference.new(self)
    end

    attr_reader :configuration

    def in_business_hours?(time)
      time_segments_on_date(time).each { |time_segment| return true if time_segment.include?(time) }

      false
    end

    def business_hours_on_date(date)
      return {} unless business_hours_include?(date.wday)

      configuration.business_hours[Sundial::WEEK_DAYS[date.wday]]
    end

    def time_segments_on_date(date)
      business_hours_on_date(date).map { |start_time, end_time|
        Sundial::TimeSegment.new(
          Time.new(date.year, date.month, date.day, start_time.to_i),
          Time.new(date.year, date.month, date.day, end_time.to_i))
        }
    end

    def business_time_between(start_time, end_time)
      raise ArgumentError.new("The end time must be later than the start time.") if start_time > end_time

      @time_difference_calculator.business_time_between(start_time, end_time)
    end

    private

    def business_hours_include?(wday)
      configuration.business_hours.keys.include?(Sundial::WEEK_DAYS[wday])
    end
  end
end
