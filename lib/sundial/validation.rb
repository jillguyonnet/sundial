module Sundial
  class Validation
    def self.perform(config)
      new(config).perform
    end

    def initialize(config)
      @config = config
    end

    def perform
      RULES.each { |rule| rule.check(@config) }

      self
    end

    class Rule
      attr_reader :message, :condition

      def initialize(message, &condition)
        @message   = message
        @condition = condition
      end

      def check(config)
        raise ArgumentError.new(message) unless condition.call(config)
      end
    end

    RULES = [
      Rule.new('business hours is not a Hash') { |config|
        config.business_hours.is_a?(Hash)
      },
      Rule.new('invalid key in business hours') { |config|
        config.business_hours.is_a?(Hash) && (config.business_hours.keys - [:mon, :tue, :wed, :thu, :fri, :sat, :sun]).empty?
      }
    ].freeze

    private_constant :RULES
  end
end
