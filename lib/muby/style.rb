module Muby

  #
  # The encapsulation of all the ncurses horror.
  #
  class Style

    include Muby::Logger
    include Muby::Configurable

    attr_reader :attributes, :color1, :color2

    class ColorPair
      @@instances = []
      @@initialized = false
      def self.init_pairs
        unless @@initialized
          1.upto(Ncurses.COLOR_PAIRS - 1) do |n|
            @@instances << ColorPair.new(n)
          end
	  @@initialized = true
        end
      end
      def self.get_pair(fg, bg)
        init_pairs
        
        found = @@instances.find do |color|
          color.bg == bg && color.fg == fg
        end

        found = @@instances.find do |color|
          color.bg.nil? && color.fg.nil?
        end unless found
        
        found = @@instances.sort do |c1, c2|
          c1.used_at <=> c2.used_at
        end.first unless found
        
        found.use(fg, bg)
        
        found
      end

      attr_accessor :bg, :fg, :number, :used_at

      def initialize(number)
        @number = number
        @used_at = Time.new
      end

      def to_i
        Ncurses.COLOR_PAIR(@number)
      end

      def use(fg, bg)
        @used_at = Time.new
        if (bg != @bg || fg != @fg)
          @bg = bg
          @fg = fg
          Ncurses.init_pair(@number, @fg, @bg)
        end
      end
    end

    def initialize(attributes, color1, color2, toAdd = false)
      @attributes = attributes
      @color1 = color1
      @color2 = color2
      @toAdd = toAdd
    end

    #
    # Get a Style instance from a window (so we can save it and restore it)
    #
    def self.extract(window)
      tmp = []
      oldAttributes = []
      oldAttribute = 0
      oldColorPair = []
      oldColor1 = []
      oldColor2 = []

      window.wattr_get(oldAttributes,oldColorPair,tmp)
      oldAttribute = oldAttributes[0] ^ Ncurses.COLOR_PAIR(oldColorPair[0])
      Ncurses.pair_content(oldColorPair[0], oldColor1, oldColor2)

      Muby::Style.new(oldAttribute, oldColor1[0], oldColor2[0])
    end

    #
    # Affect the window, either overwriting its style or adding to it.
    #
    def affect(window)
      if @toAdd
        window.wattron(to_int(window))
      else
        window.wattrset(to_int(window))
      end
    end

    def get_color_value(fg, bg)
      Muby::Style::ColorPair.get_pair(fg, bg).to_i
    end

    #
    # Get an int representation of this style, to send to ncurses.
    #
    def to_int(window)
      oldAttributes = self.class.extract(window)
      color1 = @color1 == :copy ? oldAttributes.color1 : @color1 || conf.default_colors[0]
      color2 = @color2 == :copy ? oldAttributes.color2 : @color2 || conf.default_colors[1]
      @attributes | get_color_value(color1, color2)
    end

  end # class Style

  module Styled
    unless defined?(RED)
      RED = Muby::Style.new(0, Ncurses.const_get("COLOR_RED"), :copy, true)
      BLACK = Muby::Style.new(0, Ncurses.const_get("COLOR_BLACK"), :copy, true)
      GREEN = Muby::Style.new(0, Ncurses.const_get("COLOR_GREEN"), :copy, true)
      YELLOW = Muby::Style.new(0, Ncurses.const_get("COLOR_YELLOW"), :copy, true)
      MAGENTA = Muby::Style.new(0, Ncurses.const_get("COLOR_MAGENTA"), :copy, true)
      BLUE = Muby::Style.new(0, Ncurses.const_get("COLOR_BLUE"), :copy, true)
      CYAN = Muby::Style.new(0, Ncurses.const_get("COLOR_CYAN"), :copy, true)
      WHITE = Muby::Style.new(0, Ncurses.const_get("COLOR_WHITE"), :copy, true)
      
      BOLD = Muby::Style.new(Ncurses.const_get("A_BOLD"), :copy, :copy, true)
      DIM = Muby::Style.new(Ncurses.const_get("A_DIM"), :copy, :copy, true)
      UNDERLINE = Muby::Style.new(Ncurses.const_get("A_UNDERLINE"), :copy, :copy, true)
      BLINK = Muby::Style.new(Ncurses.const_get("A_BLINK"), :copy, :copy, true)
      REVERSE = Muby::Style.new(Ncurses.const_get("A_REVERSE"), :copy, :copy, true)
      INVIS = Muby::Style.new(Ncurses.const_get("A_INVIS"), :copy, :copy, true)
      STANDOUT = Muby::Style.new(Ncurses.const_get("A_STANDOUT"), :copy, :copy, true)
      PROTECT = Muby::Style.new(Ncurses.const_get("A_PROTECT"), :copy, :copy, true)
      ALTCHARSET = Muby::Style.new(Ncurses.const_get("A_ALTCHARSET"), :copy, :copy, true)
      CHARTEXT = Muby::Style.new(Ncurses.const_get("A_CHARTEXT"), :copy, :copy, true)
      
      NORMAL = Muby::Style.new(Ncurses.const_get("A_NORMAL"), :copy, :copy, false)
    end
  end
end
