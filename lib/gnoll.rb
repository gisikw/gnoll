class GnollClass
  def initialize(source=nil)
    @fail_chain = []
    @fail_caller = nil
    @source = source unless source.class == self.class
  end

  def _errors
    puts "NoMethodError: Undefined method '#{@fail_chain[0][0]}' for #{@fail_chain[0][1]}:#{@fail_chain[0][2]}"
    puts "\t#{@fail_caller}"
    puts "\tSubsequent calls:" if @fail_chain.size > 1
    for m in @fail_chain[1..-1]
      puts "\t:#{m}"
    end
    return nil
  end

  %w{to_s inspect}.each do |m|
    define_method m do
      (@source||nil).send(m)
    end
  end

  def method_missing(*args,&block)
    if @source && @source.respond_to?(args[0])
      self.class.new(@source.send(*args,&block))
    else
      if @fail_chain.empty?
        @fail_caller = caller[0]
        @fail_chain << [args[0],@source.inspect,@source.class.inspect]
      else
        @fail_chain << "#{args[0]}"
      end
      @source = nil
      return self
    end
  end
end

class Object
  GNOLLCLASS = GnollClass
  def nil!
    GNOLLCLASS.new(self) 
  end
end

Object.send(:remove_const,:GnollClass)
