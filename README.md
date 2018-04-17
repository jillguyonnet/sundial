# Sundial

A simple Ruby gem allowing to configure a weekly schedule and query the following:
- if a given time is in or out of business hours;
- what are the business hours on a given date;
- how much business time has elapsed between two times.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sundial'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sundial

## Usage

First, create a schedule:

```ruby
business_hours = {
  mon: ['09:00', '17:00'],
  tue: ['09:00', '17:00'],
  wed: ['09:00', '17:00'],
  thu: ['09:00', '17:00'],
  fri: ['09:00', '17:00']
}

schedule = Sundial::Schedule.new(business_hours)
```

### Checking if a given time is in business hours

To check if a given time is in business hours according to the schedule above, use:

```ruby
# 14 February 2018 was a Wednesday (business hours = 9am to 5pm)
t = Time.new(2018, 2, 14, 12, 30)
schedule.in_business_hours?(t) # true
t2 = Time.new(2018, 2, 14, 19, 30)
schedule.in_business_hours?(t2) # false
```

### Business hours on a given date

To query the business hours on a given date, use the `business_hours_on_day(time)` method, which returns an array with the start and end time in string format:

```
t = Time.new(2018, 2, 14) # Wednesday
schedule.business_hours_on_day(t) # ['09:00', '17:00']
t2 = Time.new(2018, 2, 17) # Saturday
schedule.business_hours_on_day(t2) # []
```

### Calculate elapsed business time between two given times

To calculate the elapsed business time using your schedule, simply use `schedule.elapsed(from, to)`, where `from` and `to` are `Time` objects. This method returns a `Sundial::Duration` object, which can return how many seconds, minutes or hours (as integers) are contained in the elapsed time:

```ruby
# 14 February 2018 was a Wednesday (business hours = 9am to 5pm)
start_time = Time.new(2018, 2, 14, 10, 0, 0)
end_time   = Time.new(2018, 2, 14, 11, 2, 5)

duration = schedule.elapsed(start_time, end_time) # Sundial::Duration

puts duration.in_seconds # 3725
puts duration.in_minutes # 62
puts duration.in_hours   # 1
```

More examples:

```ruby
# 14 February 2018 was a Wednesday (business hours = 9am to 5pm)
schedule.elapsed(Time.new(2018, 2, 14, 7), Time.new(2018, 2, 14, 10)).in_hours # 1
schedule.elapsed(Time.new(2018, 2, 14, 9), Time.new(2018, 2, 14, 20)).in_hours # 8
```

```ruby
# From Wednesday 14 February 2018 to Thursday 15 February 2018 (business hours = 9am to 5pm)
schedule.elapsed(Time.new(2018, 2, 14, 10), Time.new(2018, 2, 15, 13)).in_hours # 11
schedule.elapsed(Time.new(2018, 2, 14, 19), Time.new(2018, 2, 15, 10)).in_hours # 1
```

```ruby
# Saturday and Sunday are not listed in the schedule, so they are not taken into account
# 16 February 2018 was a Friday (business hours = 9am to 5pm)
# 19 February 2018 was a Monday (business hours = 9am to 5pm)
schedule.elapsed(Time.new(2018, 2, 16, 12), Time.new(2018, 2, 19, 9)).in_hours # 5
```

### Testing

```ruby
bundle exec rspec
```

## Acknowledgements

WIP
