module Sundial
  class TimeDifference
    def initialize(schedule)
      @business_hours = schedule.business_hours
    end

    def elapsed(start_time, end_time)
      raise ArgumentError.new("The end time must be later than the start time.") if start_time > end_time

      reference = Sundial::TimeSegment.new(start_time, end_time)
      schedule_time_segments(start_time, end_time).map { |business_hours| business_hours & reference }.map(&:duration).reduce(Sundial::Duration.new(0), :+)
    end

    private

    def schedule_time_segments(start_time, end_time)
      segments = []
      t = start_time - Sundial::SECONDS_PER_DAY # start day before

      while t < end_time + Sundial::SECONDS_PER_DAY
        if @business_hours.keys.include?(Sundial::WEEK_DAYS[t.wday])
          @business_hours[Sundial::WEEK_DAYS[t.wday]].each do |key, value|
            segments.push(Sundial::TimeSegment.new(
              Time.new(t.year, t.month, t.day, key.to_i),
              Time.new(t.year, t.month, t.day, value.to_i)
            ))
          end
        end

        t += Sundial::SECONDS_PER_DAY
      end

      segments
    end
  end
end
