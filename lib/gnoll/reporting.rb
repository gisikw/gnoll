module Gnoll
  class Reporting < Gnoll::Base
    def initialize(source=nil)
      @method_chain = []
      super(source)
    end

    def _errors
      failed = false
      0.step(@method_chain.size-1,3) do |i|
        skip if @method_chain[i+1].respond_to?(@method_chain[i]) && !failed
        if failed
          puts "\t:#{@method_chain[i]}" 
        else
          failed = true
          puts "NoMethodError: Undefined method '#{@method_chain[i]}' for #{@method_chain[i+1].inspect}:#{@method_chain[i+1].class}"
          puts "\t#{@method_chain[i+2]}"
          puts "\tSubsequent calls:" if @method_chain[i+3]
        end
      end
      return nil
    end

    def method_missing(*args,&block)
      @method_chain << args[0] << (@source && @source.dup) << caller[0]
      super(*args,&block)
    end
  end
end
