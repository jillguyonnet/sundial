module Sundial
  class Schedule
    def initialize(&config)
      @configuration = Configuration.new(&config)
      @time_difference_calculator = TimeDifference.new(self)
    end

    attr_reader :configuration

    def in_business_hours?(time)
      return false unless configuration.business_hours.keys.include?(Sundial::WEEK_DAYS[time.wday])

      configuration.business_hours[Sundial::WEEK_DAYS[time.wday]].keys.each do |start|
        return true if time >= Time.new(time.year, time.month, time.day, start.to_i) && time <= Time.new(time.year, time.month, time.day, configuration.business_hours[Sundial::WEEK_DAYS[time.wday]][start].to_i)
      end

      false
    end

    def business_hours_on_date(date)
      return {} unless configuration.business_hours.keys.include?(Sundial::WEEK_DAYS[date.wday])

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
  end
end
