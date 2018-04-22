require 'date'

module Sundial
  class << self
    attr_writer :schedule

    def configure(&config)
      @schedule = Schedule.new(&config)
    end

    def method_missing(method, *args)
      schedule.send(method, *args) if schedule.respond_to?(method)
    end

    private

    def schedule
      @schedule or raise 'No schedule configured'
    end
  end
end

require 'sundial/configuration'
require 'sundial/constants'
require 'sundial/duration'
require 'sundial/schedule'
require 'sundial/time_segment'
require 'sundial/time_difference'
require 'sundial/validation'
require 'sundial/version'
