module Gnoll
  module Config
    extend self

    @reporting_enabled = true

    def enable_reporting?
      @reporting_enabled
    end

    def enable_reporting!
      @reporting_enabled = true
    end

    def disable_reporting!
      @reporting_disabled = true
    end

  end
end
