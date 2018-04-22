module Sundial
  class Configuration
    attr_accessor :business_hours

    def initialize
      yield self

      Validation.perform(self)
    end
  end
end
