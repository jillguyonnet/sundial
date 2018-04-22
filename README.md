# Sundial

A simple Ruby gem allowing to configure a weekly schedule and query the following:
- if a given time is in or out of business hours;
- what are the business hours on a given date;
- the amount of business time between two times.

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

First, configure your schedule:

```ruby
Sundial.configure do |config|
  config.business_hours = {
    mon: {'09:00' => '17:00'},
    tue: {'09:00' => '17:00'},
    wed: {'09:00' => '12:00', '13:00' => '17:00'},
    thu: {'09:00' => '20:00'},
    fri: {'09:00' => '12:00'}
  }
end
```

### Checking if a given time is in business hours

To check if a given time is in business hours according to the schedule above, use:

```ruby
# 14 February 2018 was a Wednesday (business hours = 9am to 12pm, 1pm to 5pm)
t = Time.new(2018, 2, 14, 12, 30)
puts Sundial.in_business_hours?(t) # false
t2 = Time.new(2018, 2, 14, 14, 30)
puts Sundial.in_business_hours?(t2) # true
```

### Business hours on a given date

To query the business hours on a given date, use the `business_hours_on_date` method, which returns a hash with the business hours time frames in string format:

```ruby
t = Time.new(2018, 2, 14) # Wednesday
puts Sundial.business_hours_on_date(t) # {'09:00' => '12:00', '13:00' => '17:00'}
d = Date.new(2018, 2, 17) # Saturday
puts Sundial.business_hours_on_date(d) # {}
```

### Calculate business time between two given times

To calculate the business time between two given times using your schedule, simply use `Sundial.business_time_between(from, to)`, where `from` and `to` are `Time` objects. This method returns a `Sundial::Duration` object, which can be expressed in seconds, minutes or hours:

```ruby
# 14 February 2018 was a Wednesday (business hours = 9am to 12pm, 1pm to 5pm)
start_time = Time.new(2018, 2, 14, 8)
end_time   = Time.new(2018, 2, 14, 19)

duration = Sundial.business_time_between(start_time, end_time) # Sundial::Duration

puts duration.in_seconds # 25200
puts duration.in_minutes # 420
puts duration.in_hours   # 7
```

More examples:

```ruby
# 14 February 2018 was a Wednesday (business hours = 9am to 12pm, 1pm to 5pm)
puts Sundial.business_time_between(Time.new(2018, 2, 14, 7), Time.new(2018, 2, 14, 10)).in_hours # 1
puts Sundial.business_time_between(Time.new(2018, 2, 14, 7), Time.new(2018, 2, 14, 20)).in_hours # 7
```

```ruby
# From Monday 12 February 2018 to Tuesday 13 February 2018 (business hours = 9am to 5pm)
puts Sundial.business_time_between(Time.new(2018, 2, 12, 10), Time.new(2018, 2, 13, 13)).in_hours # 11
puts Sundial.business_time_between(Time.new(2018, 2, 12, 19), Time.new(2018, 2, 13, 10)).in_hours # 1
```

```ruby
# Saturday and Sunday are not listed in the schedule, so they are not taken into account
# 16 February 2018 was a Friday (business hours = 9am to 12pm)
# 19 February 2018 was a Monday (business hours = 9am to 5pm)
puts Sundial.business_time_between(Time.new(2018, 2, 16, 14), Time.new(2018, 2, 19, 10)).in_hours # 1
```

### Testing

```ruby
bundle exec rspec
```

## Acknowledgements

WIP
