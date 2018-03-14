module Sundial
  MINUTE_SECONDS = 60
  HOUR_MINUTES   = 60
  DAY_HOURS      = 24
  WEEK_DAYS      = 7

  HOUR_SECONDS = HOUR_MINUTES * MINUTE_SECONDS
  DAY_SECONDS  = DAY_HOURS * HOUR_SECONDS

  DAY_MINUTES  = DAY_HOURS * HOUR_MINUTES
  WEEK_MINUTES = WEEK_DAYS * DAY_MINUTES

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
