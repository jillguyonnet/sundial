# Sundial

A simple Ruby gem allowing to configure a weekly schedule and calculate how much business time has elapsed between two dates.

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
hours = {
  mon: ['09:00', '17:00'],
  tue: ['09:00', '17:00'],
  wed: ['09:00', '17:00'],
  thu: ['09:00', '17:00'],
  fri: ['09:00', '17:00']
}

schedule = Sundial::Schedule.new(hours)
```

To calculate the elapsed business time using your schedule, simply use `schedule.elapsed(from, to)`, where `from` and `to` are `Time` objects. This method returns a `Sundial::Duration` object, which can return how many seconds, minutes or hours (as integers) are contained in the elapsed time:

```ruby
start_time = Time.new(2018, 2, 14, 10, 0, 0)
end_time   = Time.new(2018, 2, 14, 11, 2, 5)

duration = schedule.elapsed(start_time, end_time) # Sundial::Duration

puts duration.in_seconds # 3725
puts duration.in_minutes # 62
puts duration.in_hours   # 1
```

### More examples

The following examples use the schedule defined above and illustrate how only business time is taken into account.

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
