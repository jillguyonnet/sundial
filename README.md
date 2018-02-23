# Sundial

A simple Ruby gem to perform time calculations using schedules.

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

### Configuration

```ruby
schedule = Sundial::Schedule.new

schedule.config.hours = {
    mon: {'09:00' => '17:00'},
    tue: {'00:00' => '17:00'},
    wed: {'09:00' => '17:00'},
    thu: {'09:00' => '17:00'},
    sat: {'10:00' => '12:00'}
  }
```

### Operations

```ruby
# Time difference
start_time = Time.new(2018, 2, 14, 9, 15, 1)
end_time = Time.new(2018, 2, 23, 14, 33, 17)

schedule.elapsed(start_time, end_time).in_seconds
schedule.elapsed(start_time, end_time).in_minutes
schedule.elapsed(start_time, end_time).in_hours
schedule.elapsed(start_time, end_time).in_days
```

### Testing

```ruby
bundle exec rspec
```

## Acknowledgements

WIP
