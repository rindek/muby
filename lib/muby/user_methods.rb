
module Muby

  #
  # This is the UserMethod module.
  #
  # It is supposed to contain all the muby kernel methods that are
  # supposed to be used by the user or the key_commands.
  #
  module UserMethods

    def help
      help = <<ENDTEXT
##################
# muby help text #
##################

 http://jrandomhacker.info/Muby
 http://rubyforge.org/projects/muby

= Common Issues =

Typing commands within muby:
Begin your command with the / character.

Connecting to Aardwolf:
/connect "aardmud.org", 4010

== Keyboard Settings ==

Check your backspace and left/right keys!

--------------------------------------------------------------
You can scroll up to view earlier text with the 'Page Up' key.
--------------------------------------------------------------

This help text will no longer be automatically displayed once you
have edited the user_edited_config_file property of your
configuration file.

(Then, you could type /help or press F1 to get the help text again)

The configuration file the system has tried to create for you
is at #{File.expand_path(conf.loaded_rc_file)}.
ENDTEXT
      info help
    end

    #
    # Set the text to display in the top border of the input box.
    #
    def set_status_line(message)
      @statusLine = message
      update
    end

    #
    # Get the current text in the top border of the input box.
    #
    def get_status_line
      @statusLine
    end

    #
    # Set the text to display in the bottom border of the input box.
    #
    def set_message_line(message)
      @messageLine = message
      update
    end

    #
    # Get the current text in the top border of the input box.
    #
    def get_message_line
      @messageLine
    end

    def disconnect
      c = @connection
      @connection = nil
      c.close if c
    end

    def quit
      disconnect
      exit
    end

    #
    # Reconnect to last connected host
    #
    def reconnect
      if @last_host && @last_port
        connect(@last_host, @last_port)
      else
        echo("No last connection known")
      end
    end

    def connected?
      !!@connection
    end

    #
    # Connect to a host
    #
    def connect(host, port)
      disconnect
      @last_host = host
      @last_port = port
      rescue_thread do
        @connection = Muby::Connection.new(self, Muby::OutputWindow.get_instance, host, port)
      end
      "Connecting"
    end

    #
    # Do block in a thread that displays errors that happen.
    #
    def rescue_thread(&block)
      Thread.new do
        begin
          yield
        rescue Exception => e
          exception(e)
        end
      end
    end

    #
    # Make a fake connection for debug purposes
    #
    def fake_connect
      @connection = Muby::Connection.new(self, Muby::OutputWindow.get_instance, nil, nil)
      nil
    end

    #
    # Send a message to the server, with no \n
    #
    def sendn(string, echo = true)
      echo(string) if echo
      @connection.send(string) if @connection
      log_output(string)
    end

    # Send a message to the server, with a \n
    def send(string, echo = true)
      sendn("#{string}\n", echo)
    end

    def receive(string)
      @connection.feed(string) if @connection
    end

    def ignore_command!(inwin, outwin, match)
      echo(match[0])
      nil
    end

    def shell_command!(inwin, outwin, match)
      echo(match[0])
      if match[1] == "cd.."
          Dir.chdir("..")
      elsif subMatch = match[1].match(/^cd\s+(\S+.*)$/)
        Dir.chdir(subMatch[1])
      else
        execute_with_verbosity(:info, "`#{match[1]}`")
      end
      nil
    end

    def execute_command!(inwin, outwin, match)
      echo(match[0])
      execute(match[1])
      nil
    end

    def process_buffer!(inwin, outwin, c)
      toggle_history_search! if @handle_mode == :history_search!
      Muby::Completer.get_instance.store(@buffer) if conf.feed_completer_with_history
      @historyPointer = nil
      if @history[-1] != @buffer
        @history.push(@buffer.strip)
      end
      if @history.size > conf.max_history
        @history.shift
      end
      @buffer << c.chr
      conf.local_triggers.each do |regexp, command|
        begin
          if match = @buffer.match(regexp)
            @buffer = "" unless execute(command, self, Muby::OutputWindow.get_instance, match)
          end
        rescue RegexpError => error
          conf.local_triggers.delete(key)
          exception(error)
        end
      end
      sendn(@buffer) unless @buffer.empty?
      @buffer = ""
      @cursorPosition = 0
      update
      nil
    end

    def backspace_buffer!
      if @handle_mode == :history_search!
        if @cursorPosition > 1
          @search_buffer = @search_buffer[0...-1]
          @cursorPosition -= 1
          update_history_search!
        end
      else
        if @cursorPosition > 0
          @buffer = @buffer[0, @cursorPosition - 1] + @buffer[@cursorPosition, @buffer.size - @cursorPosition]
          @cursorPosition -= 1
          update
        end
      end
      nil
    end

    def word_backspace_buffer!
      unless @handle_mode == :history_search!
        if @cursorPosition > 0
          while @cursorPosition != 0 && @buffer[@cursorPosition - 1].chr.match("\\W")
            @buffer = @buffer[0, @cursorPosition - 1] + @buffer[@cursorPosition, @buffer.size - @cursorPosition]
            @cursorPosition = @cursorPosition - 1
          end
          while @cursorPosition != 0 && @buffer[@cursorPosition - 1].chr.match("\\w")
            @buffer = @buffer[0, @cursorPosition - 1] + @buffer[@cursorPosition, @buffer.size - @cursorPosition]
            @cursorPosition = @cursorPosition - 1
          end
          update
        end
      end
      nil
    end

    def delete_buffer!
      unless @handle_mode == :history_search!
        if @cursorPosition < @buffer.size
          @buffer = @buffer[0, @cursorPosition] + @buffer[@cursorPosition + 1, @buffer.size - @cursorPosition - 1]
          update
        end
      end
      nil
    end

    def resize_application!
      Muby::OutputWindow.get_instance.resize!
      Muby::InputWindow.get_instance.resize!
    end

    def reload_application!
      resize_application!
      conf.reload_application!
      Muby::InputWindow.get_instance.reload!
    end

    def complete!
      unless @handle_mode == :history_search!
        last_word = @buffer.match(/(\w*)$/)[1]
        completions = Muby::Completer.get_instance.complete(last_word)
        if completions.size == 1
          @buffer.gsub!(last_word, completions[0])
          @cursorPosition = @buffer.size
          update
        else
          info(completions.inspect)
        end
      end
      nil
    end

    def update_history_buffer!
      if @historyPointer && @history.size > 0
        @buffer = @history[@historyPointer].clone
      else
        @buffer = ""
      end
      @cursorPosition = @buffer.size
      update
      nil
    end

    def previous_history_buffer!
      if @handle_mode == :append_buffer!
        if @history.size > 0
          if @historyPointer && @historyPointer > 0
            @historyPointer -= 1
          elsif @historyPointer.nil?
            @historyPointer = @history.size - 1
          end
          update_history_buffer!
        end
      else
        @historyPointer += 1
        update_history_search!
      end
      nil
    end

    def next_history_buffer!
      if @handle_mode == :append_buffer!
        if @history.size > 0 && @historyPointer
          if @historyPointer < @history.size - 1
            @historyPointer += 1
          else
            @historyPointer = nil
          end
          update_history_buffer!
        end
      else
        @historyPointer -= 1
        update_history_search!
      end
      nil
    end

    def next_word_buffer!
      unless @handle_mode == :history_search!
        if @buffer.size > 0
          start = @cursorPosition
          @cursorPosition = (@cursorPosition + 1) % (@buffer.size)
          while @cursorPosition != 0 && @cursorPosition != @buffer.size && @cursorPosition != start && @buffer[@cursorPosition].chr.match("\\w")
            @cursorPosition = (@cursorPosition + 1) % (@buffer.size + 1)
          end
          update
        end
      end
      nil
    end

    def home_buffer!
      unless @handle_mode == :history_search!
        @cursorPosition = 0
        update
      end
      nil
    end

    def previous_word_buffer!
      unless @handle_mode == :history_search!
        if @buffer.size > 0
          start = @cursorPosition
          @cursorPosition = (@cursorPosition - 1) % (@buffer.size)
          while @cursorPosition != 0 && @cursorPosition != @buffer.size && @cursorPosition != start && @buffer[@cursorPosition].chr.match("\\w")
            @cursorPosition = (@cursorPosition - 1) % (@buffer.size + 1)
          end
          update
        end
      end
      nil
    end

    def previous_character_buffer!
      unless @handle_mode == :history_search!
        if @buffer.size > 0
          @cursorPosition = (@cursorPosition - 1) % (@buffer.size + 1)
          update
        end
      end
      nil
    end

    def next_character_buffer!
      unless @handle_mode == :history_search!
        if @buffer.size > 0
          @cursorPosition = (@cursorPosition + 1) % (@buffer.size + 1)
          update
        end
      end
      nil
    end

    def end_buffer!
      unless @handle_mode == :history_search!
        @cursorPosition = @buffer.size
        update
      end
      nil
    end

    def two_step_quit!
      if @user_quit then
        quit
      else
        @user_quit = true
        info "Press <key> again within 5 seconds to quit."
        Thread.new do
          sleep(5)
          @user_quit = false
        end
      end
      nil
    end

    def toggle_history_search!
      if @handle_mode == :append_buffer!
        enable_history_search!
      else
        disable_history_search!
      end
      nil
    end

    def enable_history_search!
      if @handle_mode == :append_buffer!
        @historyPointer = 0
        @handle_mode = :history_search!
        @search_buffer = @buffer
        update_history_search!
      end
      nil
    end

    def disable_history_search!
      unless @handle_mode == :append_buffer!
        @historyPointer = nil
        @handle_mode = :append_buffer!
        @buffer = @found_history || ""
        @cursorPosition = @buffer.size
        @search_buffer = ""
        update
      end
      nil
    end

    def update_history_search!
      @search_buffer ||= ""
      @found_history_array = @history.reverse.select do |line|
        line.match(Regexp.new(@search_buffer))
      end
      @found_history_array << "" if @found_history_array.empty?
      @found_history = @found_history_array[@historyPointer % @found_history_array.size]
      @buffer = "(#{@search_buffer}): `#{@found_history}`"
      @cursorPosition = @search_buffer.size + 1
      update
    end

    def history_search!(c)
      @search_buffer << c.chr
      update_history_search!
    end

    def append_buffer!(c)
      @buffer = @buffer[0, @cursorPosition] + c.chr + @buffer[@cursorPosition, @buffer.size - @cursorPosition]
      @cursorPosition = @cursorPosition + 1
      update
      nil
    end

    def scroll_up!(input_window)
      Muby::OutputWindow.get_instance.scroll_up(input_window)
      nil
    end

    def scroll_down!(input_window)
      Muby::OutputWindow.get_instance.scroll_down(input_window)
      nil
    end

    def toggle_verbosity!
      conf.toggle_verbosity!
      nil
    end

    def print(*message)
      oldStyle = Muby::Style.extract(Muby::OutputWindow.get_instance.outputBuffer)
      Muby::OutputWindow.get_instance.print(*(message + [oldStyle]))
    end

    #
    # Echoes a message, if we want to (conf.echo)
    #
    def echo(*message)
      if conf.echo
        style = Muby::Style.new(conf.echo_attributes, conf.echo_colors[0], conf.echo_colors[1])
        oldStyle = Muby::Style.extract(Muby::OutputWindow.get_instance.outputBuffer)
        Muby::OutputWindow.get_instance.print_on_newline(*([style] + message + [oldStyle]))
      end
    end
  end

end
