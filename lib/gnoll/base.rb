module Gnoll
  class Base

    def initialize(source=nil)
      @source = source unless source.class == self.class
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
        @source &&= nil
        return self
      end
    end

  end
end
