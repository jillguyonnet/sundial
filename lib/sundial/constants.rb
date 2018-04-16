module Sundial
  SECONDS_PER_MINUTE = 60
  MINUTES_PER_HOUR   = 60
  HOURS_PER_DAY      = 24
  DAYS_PER_WEEK      = 7

  SECONDS_PER_HOUR   = MINUTES_PER_HOUR * SECONDS_PER_MINUTE
  SECONDS_PER_DAY    = HOURS_PER_DAY * SECONDS_PER_HOUR

  MINUTES_PER_DAY    = HOURS_PER_DAY * MINUTES_PER_HOUR
  MINUTES_PER_WEEK   = DAYS_PER_WEEK * MINUTES_PER_DAY

  WEEK_DAYS = {
    1 => :mon,
    2 => :tue,
    3 => :wed,
    4 => :thu,
    5 => :fri,
    6 => :sat,
    7 => :sun
  }
end
