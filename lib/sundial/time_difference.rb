module Sundial
  class TimeDifference
    def initialize(schedule)
      @schedule = schedule
    end

    def business_time_between(start_time, end_time)
      raise ArgumentError.new("The end time must be later than the start time.") if start_time > end_time

      reference = Sundial::TimeSegment.new(start_time, end_time)

      schedule_time_segments(start_time, end_time).map { |business_hours|
        business_hours & reference
      }.map(&:duration).reduce(Sundial::Duration.new(0), :+)
    end

    private

    def schedule_time_segments(start_time, end_time)
      start_date = start_time.to_date
      end_date = end_time.to_date

      (start_date..end_date).flat_map { |date| @schedule.time_segments_on_date(date) }
    end
  end
end
