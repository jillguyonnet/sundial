module Sundial
  class TimeDifference
    def initialize(schedule)
      @business_hours = schedule.business_hours
    end

    def elapsed(start_time, end_time)
      reference = Sundial::TimeSegment.new(start_time, end_time)
      schedule_time_segments(start_time, end_time).map { |business_hours| business_hours & reference }.map(&:duration).reduce(Sundial::Duration.new(0), :+)
    end

    private

    def schedule_time_segments(start_time, end_time)
      segments = []
      current_time = start_time - Sundial::SECONDS_PER_DAY # start day before

      while current_time < end_time + Sundial::SECONDS_PER_DAY
        if @business_hours.keys.include?(Sundial::WEEK_DAYS[current_time.wday])
          segments.push(Sundial::TimeSegment.new(
            Time.new(current_time.year, current_time.month, current_time.day, @business_hours[Sundial::WEEK_DAYS[current_time.wday]][0].to_i),
            Time.new(current_time.year, current_time.month, current_time.day, @business_hours[Sundial::WEEK_DAYS[current_time.wday]][1].to_i)
          ))
        end

        current_time += Sundial::SECONDS_PER_DAY
      end

      segments
    end
  end
end
