
require 'socket'

#
# The class that encapsulates the actual Connection
#
class Muby::Connection

  include Muby::Logger
  include Muby::Configurable
  include Muby::Displayer

  #
  # Set it up with windows, handle and host info.
  #
  def initialize(inputWindow, outputWindow, host, port)
    @inputWindow = inputWindow
    @outputWindow = outputWindow
    status("Connecting to " + host.inspect + ":" + port.inspect)
    @host = host
    @port = port
    connect!
    conf.connect_triggers.each do |command|
      @inputWindow.execute(command, @inputWindow, @outputWindow)
    end
    status("Connected to " + host.inspect + ":" + port.inspect)
    @matchBuffer = ""
    @showBuffer = []
    @used_triggers = {}
    @listener = Thread.new do
      begin
        status("Listening thread started")
        listen
        status("Listening thread finished")
      rescue Exception => e
        exception(e)
      ensure
        close
      end
    end if @socket
  end

  #
  # Almost ripped from the documentation: http://www.ruby-doc.org/core/classes/Socket.src/M002114.html
  #
  def connect!
    @socket = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM, 0)
    addr = Socket.sockaddr_in(@port, @host)
    begin
      @socket.connect_nonblock(addr)
    rescue Errno::EINPROGRESS
      IO.select(nil, [@socket], nil, conf.connect_timeout)
      begin
        @socket.connect_nonblock(addr)
      rescue Errno::EISCONN
      rescue Errno::EALREADY
        raise "Connection timed out"
      end
    end
  end

  #
  # Display a status message in the outputwindow if wanted (conf.connection_status)
  #
  def status(message)
    if conf.connection_status
      @outputWindow.print_on_newline(*[message + "\n"])
    end
  end

  #
  # Check if we want to gag the current matchBuffer and debug about it.
  #
  # Remove the gag regexp if it is broken.
  #
  def gag(matchBuffer)
    returnValue = false
    conf.gags.each do |gag|
      begin
        if matchBuffer.match(gag)
          trace(matchBuffer + " matches " + gag.inspect + ": gag active")
          returnValue = true
        end
      rescue RegexpError => error
        conf.gags.delete(key)
        exception(e)
      end
    end
    returnValue = true if single_shot_gag(matchBuffer)
    returnValue
  end

  #
  # Check if we want to gag the current matchBuffer with the single shot gags and debug about it.
  # Remove all matching gags, and all gags producing regexp errors.
  #
  def single_shot_gag(matchBuffer)
    returnValue = false
    new_gags = []
    conf.single_shot_gags.each do |gag|
      this_gag_matched = false
      begin
        if matchBuffer.match(gag)
          trace(matchBuffer + " matches " + gag.inspect + ": gag active (but only once)")
          returnValue = true
          this_gag_matched = true
        end
      rescue RegexpError => error
        exception(e)
      end
      new_gags << gag unless this_gag_matched
    end
    conf.single_shot_gags = new_gags
    returnValue
  end

  #
  # Check if we should definitely NOT gag the current matchBuffer, and debug about it.
  #
  # Remove the nongag regexp if it is broken.
  #
  def nongag(matchBuffer)
    returnValue = false
    conf.anti_gags.each do |nongag|
      begin
        if matchBuffer.match(nongag)
          trace(matchBuffer + " matches " + nongag.inspect + ": nongag active")
          returnValue = true
        end
      rescue RegexpError => error
        conf.anti_gags.delete(key)
        exception(e) 
      end
    end
    returnValue
  end

  #
  # Check if we should trigger a Proc on the current matchBuffer, and debug about it.
  #
  # Remove the trigger regexp if it is broken.
  #
  def trigger(matchBuffer, hash, skip_used = true)
    rval = true
    hash.each do |key, value|
      if skip_used && @used_triggers.include?(key)
        trace("#{key.inspect} has already been matched on this line, skipping it")
      else
        trace("checking if " + matchBuffer + " matches " + key.inspect)
        begin
          if match = matchBuffer.match(key)
            trace(matchBuffer + " matches " + key.inspect + ": .call'ing Proc")
            # Run the procedure associated with that trigger:
            rval &&= @inputWindow.execute(value, @inputWindow, @outputWindow, match)
            @used_triggers[key] = true if skip_used
          end
          # If we received an error with the regular expression:
        rescue RegexpError => error
          hash.delete(key)
          exception(error)
        end
      end
    end
    return rval
  end

  def feed(s)
    s.unpack("C*").each do |c|
      handle(c)
    end
    nil
  end

  unless defined?(TELNET_COMMANDS)
    TELNET_COMMANDS = {
      240 => :end_of_sub_negotiation,
      241 => :noop,
      242 => :data_mark,
      243 => :break,
      249 => :go_ahead,
      250 => :sub_negotiation,
      251 => :will,
      252 => :wont,
      253 => :do,
      254 => :dont,
      255 => :iac
    }
  end

  def getc
    c = @socket.getc
    log_input(c.chr) if c
    c.ord
  end

  def process(c)
    #
    # The telnet support (just so we dont explode or something)
    #
    # We are just plain ignoring most of it atm.
    #
    if TELNET_COMMANDS[c] == :iac # this is an "interpret as command"
      c = getc
      if (next_command = TELNET_COMMANDS[c]) == :iac # if the next one as well is an iac, we actually want to display a 255
        handle_regular_character(c)
      else
        case next_command
        when :do # ignore the option negotiation
          c = getc
        when :dont # ignore the option negotiation
          c = getc
        when :will # ignore the option negotiation
          c = getc
        when :wont # ignore the option negotiation
          c = getc
        when :noop # waf?
          # do nothing
        when :data_mark
          warn("Got a data_mark (TELNET protocol) which I don't know how to handle. Expect strange behaviour...")
        when :break
          warn("Got a break (TELNET protocol) which I don't know how to handle. Expect strange behaviour...")
        when :go_ahead
          display_buffer # on a go ahead the server obviously wants us to display the @displayBuffer regardless of our conf.flush setting
        when :sub_negotiation # we just skip ahead to the end of the sub negotiation
          while TELNET_COMMANDS[c] != :end_of_sub_negotiation
            c = getc
          end
        else
          warn("Got an unknown TELNET command (#{c} -> #{c.ord} -> #{c.chr}) which I don't know how to handle. Expect strange behaviour...")
        end
      end
      return nil
    elsif c == 27 # escape char! this is probably some ANSI color or shite
      c = getc
      if c.chr == "[" # this is an ansi-something that is more than one char long
        ansiString = ""
        while !"cnRhl()HABCfsurhgKJipm".include?((c = getc).chr)
          ansiString << c.chr
        end
        if c.chr == "m" && Ncurses.has_colors? # ah, text property! i understand this!
          properties = ansiString.split(";")
          attributes = 0
          bgcolor = false
          fgcolor = false
          reset = properties.index("0")
          if reset
            properties.delete("0")
          end
          properties.each do |property|
            case property.to_i
            when 1
              attributes = attributes | Ncurses.const_get("A_BOLD")
            when 2
              attributes = attributes | Ncurses.const_get("A_DIM")
            when 4
              attributes = attributes | Ncurses.const_get("A_UNDERLINE")
            when 5
              attributes = attributes | Ncurses.const_get("A_BLINK") unless conf.disable_blink
            when 7
              attributes = attributes | Ncurses.const_get("A_REVERSE")
            when 8
              attributes = attributes | Ncurses.const_get("A_INVIS")
            when 30
              fgcolor = Ncurses.const_get("COLOR_BLACK")
            when 31
              fgcolor = Ncurses.const_get("COLOR_RED")
            when 32
              fgcolor = Ncurses.const_get("COLOR_GREEN")
            when 33
              fgcolor = Ncurses.const_get("COLOR_YELLOW")
            when 34
              fgcolor = Ncurses.const_get("COLOR_BLUE")
            when 35
              fgcolor = Ncurses.const_get("COLOR_MAGENTA")
            when 36
              fgcolor = Ncurses.const_get("COLOR_CYAN")
            when 37
              fgcolor = Ncurses.const_get("COLOR_WHITE")
            when 40
              bgcolor = Ncurses.const_get("COLOR_BLACK")
            when 41
              bgcolor = Ncurses.const_get("COLOR_RED")
            when 42
              bgcolor = Ncurses.const_get("COLOR_GREEN")
            when 43
              bgcolor = Ncurses.const_get("COLOR_YELLOW")
            when 44
              bgcolor = Ncurses.const_get("COLOR_BLUE")
            when 45
              bgcolor = Ncurses.const_get("COLOR_MAGENTA")
            when 46
              bgcolor = Ncurses.const_get("COLOR_CYAN")
            when 47
              bgcolor = Ncurses.const_get("COLOR_WHITE")
            end
          end
          style = nil
          if reset
            style = Muby::Style.new(attributes, fgcolor, bgcolor, false)
          else
            style = Muby::Style.new(attributes, fgcolor, bgcolor, true)
          end
          @showBuffer.push(style)
        end
      end
      return nil
    elsif !conf.broken_keycodes.include?(c)
      return c
    end
  end

  def append_buffers(c)
    if String === @showBuffer.last
      @showBuffer.last << c.chr
    else
      @showBuffer << c.chr
    end
    @matchBuffer = @matchBuffer + c.chr
  end

  #
  # Keep listening to the remote socket and react accordingly.
  #
  def listen
    c = true
    # While we get characters
    while c
      # While we have something to read within one second
      while select([@socket],nil,nil,1) && c = getc
        # If it is a regular character
        if regular_char = process(c)
          # Append it to our match and show buffers
          append_buffers(regular_char)
          # Trigger all remote character triggers on it
          trigger(@matchBuffer, conf.remote_character_triggers, true)
          # If it is a newline
          if regular_char == 10
            # Trigger all normal remote triggers on it
            run_remote_triggers
            display_buffer
            @matchBuffer = ""
          end
        end
      end
      trigger(@matchBuffer, conf.remote_character_triggers, true)
      run_remote_triggers
      display_buffer if conf.flush
      @matchBuffer = ""
    end
    status("Connection closed by remote end")
    @inputWindow.disconnect
  end

  def close
    if Thread.current != @listener && @listener && @listener.alive?
      status("Killing listening thread")
      @listener.kill
    end
    if @socket && !@socket.closed?
      status("Disconnecting our end")
      conf.disconnect_triggers.each do |command|
        @inputWindow.execute(command, @inputWindow, @outputWindow)
      end
      @socket.close if @socket
    end
  end

  def run_remote_triggers
    @showBuffer = [] unless trigger(@matchBuffer, conf.remote_triggers, false)
    @used_triggers = {}
  end

  def homemade_split(s, r)
    rval = []
    rest = s
    while match = rest.match(/(.*?)#{r.source}(.*)/)
      rval << match[1]
      rest = match[2]
    end
    rval << rest
    rval
  end

  def substitute(buffer, hash)
    return_value = []
    buffer.each do |part|
      if String === part
        part_to_append = [part]
        hash.each do |regexp, substitution|
          case substitution
          when String
            part_to_append = [part.gsub(regexp, substitution)]
          when Array
            if part.match(regexp)
              split_part = homemade_split(part, regexp)
              part_to_append = split_part.zip([substitution] * (split_part.size - 1)).flatten.compact
            end
          end
        end
        return_value += part_to_append
      else
        return_value << part
      end
    end
    return_value
  end
  
  def colorize(s)
    conf.colors.each do |reg, colors|
      return colors if s.match(reg)
    end
    return ["", ""]
  end

  def display_buffer
    unless @showBuffer.empty?
      if !gag(@matchBuffer) || nongag(@matchBuffer)
        @showBuffer = substitute(@showBuffer, conf.remote_substitutions)
        Muby::Completer.get_instance.store(@matchBuffer) if conf.feed_completer_with_input
        pre, post = colorize(@matchBuffer)
        @showBuffer.unshift pre
        @showBuffer.push post
        @outputWindow.print(*@showBuffer)
      end
      @showBuffer = []
    end
  end

  #
  # Just plain send the string we got.
  #
  def send(s)
    log_output(s)
    conf.local_substitutions.each do |key, value|
      # It might be useful to allow colour codes for highlighting local substitutions.. but only when echo is on.
      # No, cause this only gets sent to the server, it never shows up to the user.
      s.gsub!(key, value)
    end
    @socket.print(s) if @socket
  end
end # class Connection
