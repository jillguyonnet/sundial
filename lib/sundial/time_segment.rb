module Sundial
  class TimeSegment
    def initialize(start_time, end_time)
      raise ArgumentError.new("The end time must be later than the start time.") if start_time > end_time

      @start_time = start_time
      @end_time   = end_time
    end

    attr_reader :start_time, :end_time

    def duration
      Sundial::Duration.new(end_time - start_time)
    end

    def same_day?
      start_time.year == end_time.year && start_time.month == end_time.month && start_time.day == end_time.day
    end

    def full_days_between # FIXME: this only works if the year and month don't change!
      return [] if same_day?

      num_full_days = ((end_time - start_time) / 86400).round - 1
      full_days = []

      day = start_time.day + 1

      num_full_days.times do
        full_days << Time.new(end_time.year, end_time.month, day)
        day += 1
      end

      full_days
    end
  end
end
