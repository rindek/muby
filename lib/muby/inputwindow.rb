
require 'pathname'

#
# The fancy window that gets our input.
# 
# The class handles everything to do with
# the input window itself, the user callable
# methods are in the UserMethods module.
#
# All commands entered with conf.escape_character will be eval'd in
# this class scope.
#
class Muby::InputWindow

  include Muby::Logger
  include Muby::Configurable
  include Muby::Displayer
  include Muby::UserMethods
  include Muby::Styled
  include Muby::HelperMethods

  @@instance ||= nil
  
  def self.get_instance
    @@instance ||= Muby::InputWindow.new
  end

  attr_reader :history

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
      raise "Unable to calculate input window geometry: #{e}\n\nCheck your config file (#{conf.loaded_rc_file}) for errors in 'conf.input_window_geometry!\n\n"
    end

    # Init all the default values
    @buffer = ""
    @cursorPosition = 0
    @history = []
    @historyPointer = nil
    @connection = nil
    @statusLine = ""
    @messageLine = ""
    @recent_escape = []
    @handle_mode = :append_buffer!

    resize!

    help unless conf.user_edited_config_file
  end

  def resize!
    # Init the input box
    @inputBorder = Ncurses.newwin(height, width, top, left)
    @inputBorder.box(0,0)
    @inputBorder.keypad(true)
    @inputBorder.refresh

    # Init the window itself
    @inputWindow = Ncurses.newwin(height - 2, width - 2, top + 1, left + 1)
    @inputWindow.keypad(true)
    @inputWindow.scrollok(true)
    @inputWindow.nodelay(true)
    @inputWindow.refresh
  end
  
  def reload!
    do_startup_triggers
  end

  def left
    do_execute(conf.input_window_geometry[:left])
  end

  def top
    do_execute(conf.input_window_geometry[:top])
  end

  def width
    do_execute(conf.input_window_geometry[:width])
  end

  def height
    do_execute(conf.input_window_geometry[:height])
  end

  #
  # Update the input box, redrawing borders and text etc.
  #
  def update
    @inputBorder.box(0,0)
    @inputBorder.mvwprintw(0,1,"%s", @statusLine)
    @inputBorder.mvwprintw(height - 1, 1, "%s", @messageLine)
    @inputBorder.refresh

    @inputWindow.werase
    row = 0
    col = @cursorPosition
    while col > width - 2
      row = row + 1
      col = col - width - 2
    end
    @inputWindow.mvwprintw(row,col,"%s", @buffer[@cursorPosition,@buffer.size - @cursorPosition])
    @inputWindow.mvwprintw(0,0,"%s", @buffer[0, @cursorPosition])
    @inputWindow.refresh
  end

  #
  # Save our history into the history file.
  #
  def saveHistory
    # This should be wrapped in something else, which checks for sanity (writability)
    dir = Pathname.new(conf.history_file).parent
    dir.mkpath unless dir.exist?
    file = Pathname.new(conf.history_file)
    file.open("w") do |output|
      Marshal.dump(@history, output)
    end
  end

  #
  # Load our history from the history file.
  #
  def loadHistory
    begin
      if FileTest.readable?(conf.history_file)
        info("Reading #{conf.history_file}")
        Kernel::open(conf.history_file) do |input|
          @history = Marshal.load(input.read)
        end
        @history.each do |line|
          Muby::Completer.get_instance.store(line)
        end if conf.feed_completer_with_history
      end
    rescue Exception => e
      exception(e)
    end
    @history ||= []
  end

  def handle(c, hash)
    # Echo the keycode we got if we have conf.echo_keycodes == true (good for setting up conf.key_commands)
    if conf.echo_keycodes && c != Ncurses.const_get("ERR")
      info(c.to_s)
    end
    if hash.include?(c)
      value = hash[c]
      if Hash === value
        c = @inputWindow.wgetch
        if value.include?(c)
          handle(c, value)
        else
          handle(c, conf.key_commands)
        end
      else
        execute(value, self, Muby::OutputWindow.get_instance, c)
      end
    elsif 0 < c && c < 265
      method = self.method(@handle_mode)
      method.call(c)
    end
  end

  def do_startup_triggers
    conf.startup_triggers.each do |trigger|
      execute(trigger, self, Muby::OutputWindow.get_instance)
    end
  end

  #
  # Just keep listening to the keyboard input.
  #
  def process
    loadHistory
    do_startup_triggers
    # We need to check one key at a time due to triggers and conf.key_commands
    while c = @inputWindow.wgetch
      if c == Ncurses.const_get("ERR")
        sleep(0.01)
      else
        handle(c, conf.key_commands)
        update
      end
    end # while c = @inputWindow.wgetch
  end # def process

end # class InputWindow
