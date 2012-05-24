module Gnoll
  class Proxy < Gnoll::Config.enable_reporting? ? Gnoll::Reporting : Gnoll::Base
  end
end
