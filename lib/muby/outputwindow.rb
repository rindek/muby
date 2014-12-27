#
# The class that controls what we see.
#
class Muby::OutputWindow

  include Muby::Logger
  include Muby::Configurable
  include Muby::HelperMethods
  include Muby::Displayer

  attr_reader :scrollback, :size, :outputBuffer

  @@instance ||= nil

  def self.get_instance
    @@instance ||= Muby::OutputWindow.new
  end

  def initialize
    @ready = false
  end

  def ready?
    @ready
  end

  #
  # Start working!
  #
  def go
    # Ensure our size is calculable
    begin
      height
      width
      top
      left
    rescue Exception => e
      Ncurses.endwin
      raise "Unable to calculate output window geometry: #{e}\n\nCheck your config file (#{conf.loaded_rc_file}) for errors in 'conf.output_window_geometry!\n\n"
    end

    @scrollback = 0
    @waitBuffer = []
    @lines = 0

    @outputBuffer = Ncurses.newpad(conf.output_buffer, width)
    @outputBuffer.wclear
    @outputBuffer.scrollok(true)
    @outputBuffer.idlok(true)
    defaultAttributes = Muby::Style.new(conf.default_attributes, conf.default_colors[0], conf.default_colors[1])
    defaultAttributes.affect(@outputBuffer)
    # Prepare the output window:
    @outputBuffer.mvprintw(conf.output_buffer - 1, 0, "\n")

    show_version
    refresh

    @ready = true
  end

  def resize!
    refresh
  end

  def left
    do_execute(conf.output_window_geometry[:left])
  end

  def top
    do_execute(conf.output_window_geometry[:top])
  end

  def width
    do_execute(conf.output_window_geometry[:width])
  end

  def height
    do_execute(conf.output_window_geometry[:height])
  end

  def show_version
    print("
.--.--.--.     .--.
:        :--.--:  : .--.--.
:  :  :  :  :  :  '-:  :  :
:  :  :  :  :  :  : :  '  :
'--'--'--'-----'----'--.  :
  The Ruby MUD Client  :  :
  -------------------  '--'
     Version #{Muby::VERSION}
")
  end

  #
  # Refresh the output buffer (if we have scrolled etc)
  #
  def refresh
    @outputBuffer.prefresh(conf.output_buffer - (height * (@scrollback + 1)), 0, top, left, height - 1, width)
  end

  #
  # Scroll up, and give the user a message about it.
  #
  def scroll_up(inputWindow)
    if @scrollback * height < conf.output_buffer &&
        @scrollback * height < @lines
      @scrollback += 1
      # BUG: set_message_line is in userMethods.
      # No, its not a bug.
      inputWindow.set_message_line("SCROLLED - I/O PAUSED")
      refresh
    end
  end

  #
  # Scroll down again.
  #
  def scroll_down(inputWindow)
    if @scrollback > 0
      @scrollback -= 1
      if @scrollback == 0
        # BUG:
        # No
        inputWindow.set_message_line("")
        unless @waitBuffer.empty?
          print(*@waitBuffer)
          @waitBuffer = []
        end
      end
    end
    refresh
  end

  def timestamp(message)
    if conf.timestamp && @recent_linebreak
      Time.new.strftime(conf.timeformat) + "\t" + message
    else
      message
    end
  end

  def show(level, message)
    if conf.display?(level)
      to_print = [message, "\n"]
      if level_attributes = conf.send("#{level}_attributes")
        level_colors = conf.send("#{level}_colors")
        style = Muby::Style.new(level_attributes, level_colors[0], level_colors[1])
        oldStyle = Muby::Style.extract(@outputBuffer)
        to_print = [style] + to_print + [oldStyle]
      end

      print_on_newline(*to_print)
    end
  end

  def print_on_newline(*info)
    if @recent_linebreak
      print(*info)
    else
      print(*(["\n"] + info))
    end
  end

  #
  # Print an info Array to the outputBuffer.
  #
  # Will print text as is, and add any Styles encountered to the outputBuffer.
  #
  def print(*info)
    if @scrollback == 0
      info.each do |e|
        if String === e
          rest = e
          while (match = rest.match(/^([^\r\n]*)([\r\n]*)(.*)$/m))
            to_print = match[1]
            linebreak = match[2]
            rest = match[3]

            break if to_print.empty? and linebreak.empty?

            @outputBuffer.printw("%s", timestamp(to_print) + linebreak)

            @recent_linebreak = !linebreak.empty?
            @lines += 1 unless linebreak.empty?
          end
        elsif Muby::Style === e
          e.affect(@outputBuffer)
        end
      end
    else
      @waitBuffer += info
    end
    refresh
    nil
  end

end # class OutputWindow
