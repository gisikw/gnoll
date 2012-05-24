module Gnoll
end

require_relative 'gnoll/base'
require_relative 'gnoll/reporting'
require_relative 'gnoll/config'

Gnoll::Config.enable_reporting!
require_relative 'gnoll/proxy'

require_relative 'gnoll/core_ext/object'
