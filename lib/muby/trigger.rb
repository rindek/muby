
module Muby

  class Trigger

    class Shot
      attr_accessor :inwin, :outwin, :match, :trigger
      def initialize(trigger, inwin, outwin, match)
        @inwin = inwin
        @outinw = outwin
        @match = match
        @trigger = trigger
      end
      def remove!
        @trigger.remove!
      end
    end

    attr_accessor :regexp, :block, :type
    def initialize(type, regexp, &block)
      @regexp = regexp
      @block = block
      @type = type
      conf.send("#{@type}_triggers".to_sym)[@regexp] = self
    end
    def arity
      3
    end
    def call(inwin, outwin, match)
      block.call(Shot.new(self, inwin, outwin, match))
    end
    def remove!
      conf.send("#{@type}_triggers".to_sym).delete(@regexp)
    end
  end

end
