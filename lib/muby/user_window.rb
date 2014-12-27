
module Muby

  class UserWindow

    def initialize(options = {})
      @top = options.delete(:top)
      @left = options.delete(:left)
      @width = options.delete(:width)
      @height = options.delete(:height)
      @border = Ncurses.newwin(@height, @width, @top, @left)
      @border.box(0,0)
      @border.keypad(true)
      @border.refresh
      @window = Ncurses.newwin(@height - 2, @width - 2, @top + 1, @left + 1)
      @window.keypad(true)
      @window.scrollok(true)
      @window.nodelay(true)
      @window.refresh
    end

    def print(line, col, *info)
      @window.move(line, col)
      info.each do |e|
        if String === e
          @window.printw("%s", e)
        elsif Muby::Style === e
          e.affect(@window)
        end
      end
      @window.refresh
    end

    def clear
      @window.erase
      @window.refresh
    end

  end

end
