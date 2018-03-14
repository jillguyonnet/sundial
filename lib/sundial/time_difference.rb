module Sundial
  class TimeDifference < SimpleDelegator
    def initialize(schedule, time_segment)
      super(
        time_segment.same_day? ?
        schedule.business_time_on_day(time_segment.start_time, time_segment.end_time) :
        schedule.business_time_on_day_after(time_segment.start_time) +
          time_segment.full_days_between.map { |day| schedule.total_business_time_on_day(day) }.reduce(Sundial::Duration.new(0), :+) +
          schedule.business_time_on_day_before(time_segment.endtime)
      )
    end
  end
end
