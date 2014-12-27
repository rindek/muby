
require 'ncurses'

module Muby


  VERSION = "0.7.14" unless defined?(Muby::VERSION)
  
  #
  # The class that encapsulates all configuration.
  #
  # To simplify its use, include Muby::Configurable in your class.
  # Then you can access Configuration as 'conf' (nice shorthand :)
  #
  # All options in Configuration are get'able and set'able.
  #
  # Look in help.rb to get the meaning of them.
  #
  class Configuration

    @@instance ||= nil

    def self.get
      @@instance ||= Configuration.new
    end

    def initialize
      #
      # verbosity options
      #

      @extra_verbosity_settings = {
        :echo_keycodes => true,
        :echo => true,
        :show_level => :debug,
        :timestamp => true,
        :connection_status => true
      }

      @output_window_geometry = {
        :top => 0,
        :left => 0,
        :width => "Ncurses.COLS",
        :height => "Ncurses.LINES - Muby::InputWindow.get_instance.height"
      }

      @input_window_geometry = {
        :top => "Ncurses.LINES - conf.input_height - 2",
        :left => 0,
        :width => "Ncurses.COLS",
        :height => "conf.input_height + 2"
      }

      @single_shot_gags = []
      
      @echo_keycodes = false

      @echo = true

      @show_level = :info

      @timestamp = false

      @connection_status = true

      #
      # options to control what you see 
      #

      @disable_blink = false
      
      @timeformat = "%H:%M:%S"

      @broken_keycodes = {
        13 => true
      }

      @max_history = 100

      @default_attributes = Ncurses.const_get("A_NORMAL")
      @default_colors = [Ncurses.const_get("COLOR_WHITE"), Ncurses.const_get("COLOR_BLACK")]

      @echo_attributes = Ncurses.const_get("A_BOLD")
      @echo_colors = [Ncurses.const_get("COLOR_WHITE"), Ncurses.const_get("COLOR_BLACK")]

      @trace_attributes = Ncurses.const_get("A_NORMAL")
      @trace_colors = [Ncurses.const_get("COLOR_WHITE"), Ncurses.const_get("COLOR_BLACK")]

      @debug_attributes = Ncurses.const_get("A_NORMAL")
      @debug_colors = [Ncurses.const_get("COLOR_WHITE"), Ncurses.const_get("COLOR_BLACK")]

      @info_attributes = Ncurses.const_get("A_NORMAL")
      @info_colors = [Ncurses.const_get("COLOR_WHITE"), Ncurses.const_get("COLOR_BLACK")]

      @warn_attributes = Ncurses.const_get("A_NORMAL")
      @warn_colors = [Ncurses.const_get("COLOR_WHITE"), Ncurses.const_get("COLOR_BLACK")]

      @error_attributes = Ncurses.const_get("A_NORMAL")
      @error_colors = [Ncurses.const_get("COLOR_WHITE"), Ncurses.const_get("COLOR_BLACK")]

      @flush = true
      
      @gags = []
      
      @colors = {}

      @anti_gags = []
      
      @remote_substitutions = {}
      
      @local_substitutions = {}

      #
      # options to control what gets run when         #
      #

      @startup_triggers = []

      @disconnect_triggers = []

      @connect_triggers = []

      @shutdown_triggers = []

      @remote_triggers = {}
      
      @remote_character_triggers = {}
      
      @local_triggers = {
        /^\/(.*)\n$/m => :execute_command!,
        /^!(.*)\n$/m => :shell_command!,
        /^#.*\n$/m => :ignore_command!
      }
      
      @key_commands = {
        12 => :resize_application!, # ctrl-l
        Ncurses.const_get("KEY_PPAGE") => :scroll_up!,
        Ncurses.const_get("KEY_NPAGE") => :scroll_down!,
        Ncurses.const_get("KEY_ENTER") => :process_buffer!,
        10 => :process_buffer!, # enter
        3 => :two_step_quit!, # ctrl-c
        9 => :complete!, # tab
        18 => :toggle_history_search!, # ctrl-r
        127 => :backspace_buffer!, # backspace
        Ncurses.const_get("KEY_BACKSPACE") => :backspace_buffer!,
        27 => {
          263 => :word_backspace_buffer!, # alt-backspace
          91 => {
            49 => {
              59 => {
                53 => {
                  68 => :previous_word_buffer!, # ctrl-key_left
                  67 => :next_word_buffer!, # ctrl-key_right
                }
              }
            }
          }
        },
        Ncurses.const_get("KEY_DC") => :delete_buffer!,
        Ncurses.const_get("KEY_UP") => :previous_history_buffer!,
        Ncurses.const_get("KEY_DOWN") => :next_history_buffer!,
        262 => :home_buffer!, # home_key
        360 => :end_buffer!, # end_key
        Ncurses.const_get("KEY_LEFT") => :previous_character_buffer!,
        Ncurses.const_get("KEY_RIGHT") => :next_character_buffer!,
        22 => :toggle_verbosity!, # ctrl-v
        265 => :help # f1
      }

      #
      # miscellaneous options #
      #

      @connect_timeout = 10

      @feed_completer_with_history = true

      @feed_completer_with_input = true

      @extra_completions = []
      
      @loaded_rc_file = false

      @user_edited_config_file = false
      
      @userdir = File.join(ENV["HOME"], "mubyrc.d")

      @history_file = File.join(@userdir, "history")

      @output_buffer = 1000
      
      @input_height = 3
      
      @input_logfile = nil 
      
      @output_logfile = nil

    end

    #
    # The magical method that lets us get and set the settings without
    # having to write getters and setters for all of them
    #
    def method_missing(*args)
      method_name = args[0].to_s
      var_name = method_name[/^[^=]*/]
      
      setter = method_name =~ /=$/
      if setter
        return super unless args.size == 2
        instance_variable_set("@#{var_name}", args[1])
        return args[1]
      else
        return super unless args.size == 1
        return instance_variable_get("@#{var_name}")
      end
    end

    #
    # The halfway magical method that toggles all settings covered in
    # @extra_verbosity_settings to what they are in that hash,
    # and then stores them away inside the same hash for back-toggling again.
    #
    def toggle_verbosity!

      # copy old extra-settings to a copy
      settings_copy = @extra_verbosity_settings.clone

      # set our extra-settings to be the currently applied settings
      @extra_verbosity_settings.clone.each do |key, value|
        @extra_verbosity_settings[key] = self.send(key)
      end

      # apply the extra-settings
      settings_copy.each do |key, value|
        self.send("#{key}=", value)
      end

      Muby::Displayer.info("Toggled verbosity. Press <key> again to toggle back.")
    end

    #
    # Returns true if we are supposed to display messages
    # of +level+.
    #
    def display?(level)
      levels = [:trace, :debug, :info, :warn, :error]
      levels.index(level) >= (levels.index(@show_level) || 0)
    end

    #
    # Will save the current configuration to the loaded rc file,
    # or to mubyrc if no such file was loaded.
    #
    def save_configuration_file!
      to_save = @loaded_rc_file ? @loaded_rc_file : File.join(ENV["HOME"], "mubyrc")
      begin
        Kernel::open(to_save, "w") do |output|
          output.write(self.to_ruby)
          @loaded_rc_file = to_save
        end
        Muby::Displayer.info("Saved default configuration to #{to_save}.")
      rescue Exception => e
        Muby::Displayer.warn("Failed saving default configuration to #{to_save}: #{e.message}")
        Muby::Displayer.debug(e.backtrace.join("\n"))
      end
    end
    
    #
    # Tries to load all the users files, defined as
    # any file named .mubyrc or mubyrc in the users ENV["HOME"]
    # and all **/*.rb files in the users ENV["HOME"]/@userdir
    # with the root of the userdir taking precidence over subdirectories.
    # Directories starting with a . are ignored.
    # 
    # If none of the mubyrc-files existed, it will try to create one
    # for the user to edit to his/her liking.
    #
    def load_user_files!
      @loaded_rc_file = false
      if to_load = [".mubyrc", "mubyrc"].collect do |file_name|
          File.join(ENV["HOME"], file_name)
        end.find do |file_name|
          File.exists?(file_name)
        end
        nice_load!(to_load)
        @loaded_rc_file = to_load
      end

      unless @loaded_rc_file
        save_configuration_file!
      end
      
      if File.exists?(@userdir)
        # Only load *.rb files within sub-directories of the current directory, and not the current directory's *.rb files!)
        # Test:  Dir[File.join(Dir.pwd, "*", "**", "*.rb")].each do |f| puts f end ; nil
        Dir[File.join(@userdir, "*", "**", "*.rb")].each do |file_name|
          nice_load!(file_name)
        end
        # Only load *.rb files of the current directory.
        # This is very useful for users to create "overrides" for items in subdirectories.
        # NOTE: This does follow symbolic links (files and directories)
        # Test:  Dir[File.join(Dir.pwd, "*.rb")].each do |f| puts f end ; nil
        Dir[File.join(@userdir, "*.rb")].each do |file_name|
          nice_load!(file_name)
        end
      else
        Muby::Displayer.warn("#{@userdir} does not exist. If it did, *.rb in it would be loaded now.")
      end
    end
    
    #
    # A non-raising method that tries to load +f+ and tells the output window about its success.
    #
    def nice_load!(f)
      begin
        Kernel::load(f)
        Muby::Displayer.info("Loaded #{f}")
      rescue Exception => e
        Muby::Displayer.exception(e)
      end
    end
    
    #
    # Will reload the entire app, ie the class files and the
    # user files.
    #
    # TODO: Remove the spammyness.
    # It is not appropriate to use 'puts' when reload_application! is being called by the user.
    # To turn off "uninitialised constant" warnings, do:  $VERBOSE = nil
    #
    # Simply set your show_level to :warn instead of :info, and you wont see the load messages.
    #
    # Any other messages come from your own files :O
    #
    def reload_application!
      Dir[File.join(File.dirname(__FILE__), "**", "*.rb")].each do |file_name|
        nice_load! file_name
      end
      load_user_files!
    end
    
    #
    # The not so magical at all method that prints our content
    # to a String so that we easily can save our current settings
    # in a file, or create a default config file.
    #
    def to_ruby
      "#
# This is the default configuration of muby.
# To learn more about how to configure it, you
# can type '/help' in the client.
#
include Muby::Configurable
" +
      instance_variables.sort.collect do |var_name|
        value = eval(var_name)
        case value
        when Hash
          space = "conf.#{var_name[1..-1]} = _".size
          value = value.inspect.gsub(/, /, ",\n#{" " * space}")
        when File
          begin
            value.read(0)
            value = "open(\"#{value.path}\", \"r\")"
          rescue
            value = "open(\"#{value.path}\", \"a\")"
          end
        when NilClass
          value = value.inspect
        else
          value = value.inspect
        end
        var_name = var_name[1..-1]
        help_text = Muby::Help.configuration[var_name.to_sym] || "no help available for #{var_name}"
        help_text = help_text.split("\n").join("\n# ")
        "
# #{help_text}
conf.#{var_name} = #{value}"
      end.join("\n")
    end

  end

  #
  # The module that provides the shorthand for 
  # using classes.
  #
  module Configurable
    def conf
      Configuration.get
    end
  end
  
end
