module Sundial
  class Configuration
    attr_accessor :business_hours

    def initialize
      yield self
    end
  end
end
