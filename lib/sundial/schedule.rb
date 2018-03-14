module Sundial
  class Schedule
    def initialize(business_hours = nil)
      @business_hours = business_hours
    end

    def elapsed(from, to)
      raise ArgumentError.new("The end time must be later than the start time.") if from > to

      Sundial::TimeDifference.new(self, TimeSegment.new(from, to))
    end

    def total_business_time_on_day(time)
      hours = @business_hours[Sundial::WEEK_DAYS[time.wday]]
      if hours
        start_time_str = hours.keys.first
        end_time_str = hours.values.first
        start_time_hours, start_time_minutes = start_time_str.split(':').map(&:to_i)
        end_time_hours, end_time_minutes = end_time_str.split(':').map(&:to_i)
        time_ref = Time.now
        start_time = Time.new(time_ref.year, time_ref.month, time_ref.day, start_time_hours, start_time_minutes)
        end_time = Time.new(time_ref.year, time_ref.month, time_ref.day, end_time_hours, end_time_minutes)
        Sundial::Duration.new(end_time - start_time)
      else
        Sundial::Duration.new(0)
      end
    end

    def business_time_on_day_before(time)
      hours = @business_hours[Sundial::WEEK_DAYS[time.wday]]
      if hours
        business_start_time_str = hours.keys.first
        business_start_time_hours, business_start_time_minutes = business_start_time_str.split(':').map(&:to_i)
        business_start_time = Time.new(time.year, time.month, time.day, business_start_time_hours, business_start_time_minutes)
        return Sundial::Duration.new(0) if time < business_start_time

        business_end_time_str = hours.values.first
        business_end_time_hours, business_end_time_minutes = business_end_time_str.split(':').map(&:to_i)
        business_end_time = Time.new(time.year, time.month, time.day, business_end_time_hours, business_end_time_minutes)
        end_time = time > business_end_time ? business_end_time : time

        Sundial::Duration.new(end_time - business_start_time)
      else
        Sundial::Duration.new(0)
      end
    end

    def business_time_on_day_after(time)
      hours = @business_hours[Sundial::WEEK_DAYS[time.wday]]
      if hours
        business_end_time_str = hours.values.first
        business_end_time_hours, business_end_time_minutes = business_end_time_str.split(':').map(&:to_i)
        business_end_time = Time.new(time.year, time.month, time.day, business_end_time_hours, business_end_time_minutes)
        return Sundial::Duration.new(0) if time > business_end_time

        business_start_time_str = hours.keys.first
        business_start_time_hours, business_start_time_minutes = business_start_time_str.split(':').map(&:to_i)
        business_start_time = Time.new(time.year, time.month, time.day, business_start_time_hours, business_start_time_minutes)
        start_time = time < business_start_time ? business_start_time : time

        Sundial::Duration.new(business_end_time - start_time)
      else
        Sundial::Duration.new(0)
      end
    end

    def business_time_on_day(from, to)
      raise ArgumentError.new("The start and end times must be on the same day.") unless Sundial::TimeSegment.new(from, to).same_day?
      raise ArgumentError.new("The end time must be later than the start time.") if from > to

      hours = @business_hours[Sundial::WEEK_DAYS[from.wday]]
      if hours
        business_start_time_str = hours.keys.first
        business_start_time_hours, business_start_time_minutes = business_start_time_str.split(':').map(&:to_i)
        business_start_time = Time.new(from.year, from.month, from.day, business_start_time_hours, business_start_time_minutes)

        business_end_time_str = hours.values.first
        business_end_time_hours, business_end_time_minutes = business_end_time_str.split(':').map(&:to_i)
        business_end_time = Time.new(from.year, from.month, from.day, business_end_time_hours, business_end_time_minutes)

        return Sundial::Duration.new(0) if from > business_end_time || to < business_start_time

        start_time = from < business_start_time ? business_start_time : from
        end_time = to > business_end_time ? business_end_time : to

        Sundial::Duration.new(end_time - start_time)
      else
        Sundial::Duration.new(0)
      end
    end
  end
end
