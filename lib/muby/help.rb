module Muby

  module Help
    def self.configuration
      {
        :colors => "A Hash where the keys are regular expressions that the output is matched against, and the values are two-element-Arrays where the first element is what will be prepended to the output line and the second element what will be appended to the output line matching.",
        :connect_timeout => "The number of seconds we will try to connect before giving up.",
        :single_shot_gags => "The gags that will only be used once and then discarded. Usually created by triggers.",
        :feed_completer_with_history => "If true, the completion command will use history to calculate possible completions.",
        :feed_completer_with_input => "If true, the completion command will use everything seen from the remote end to calculate possible completions.",
        :extra_completions => "Fill this array with words that you allways want to be able to complete to.",
        :extra_verbosity_settings => "The settings we want to toggle to when running the toggle_verbosity! method.",
        :input_window_geometry => "The top and left corners of the InputWindow, and its width and height. The values will be set to what you enter here, or if they are Strings will be evaluated when the windows are set up.",
        :output_window_geometry => "The top and left corners of the OutputWindow, and its width and height. The values will be set to what you enter here, or if they are Strings will be evaluated when the windows are set up.",
        :echo_keycodes => "Whether to echo the keycode for every key pressed or not.",
        :echo => "Whether to print what is sent to the server to the outputwindow.",
        :show_level => "What level of information to provide the user.
:trace may tell you each and every step the app takes.
:debug may tell the user most everything that happens.
:info will tell the user basically what we are doing.
:warn will only tell the user when we think he/she may gain from it.
:error will only tell the user when an error occurs.",
        :timestamp => "Whether to timestamp all messages in the output window.",
        :connection_status => "Whether to give status reports on the connections.",
        :timeformat => "What type of timestamp to use.",
        :loaded_rc_file => "This will be set to whichever mubyrc file was loaded upon startup.",
        :disable_blink => "Set this to true if you NEVER want to see BLINKING text from the server.",
        :broken_keycodes => "Which characters to filter out completely.",
        :max_history => "The maximum length of the history buffer.",
        :user_edited_config_file => "Change this to true when you dont want to see the help message anymore.",
        :default_attributes => "The default ncurses attributes for text.",
        :default_colors => "The default ncurses colors for text.",
        :echo_attributes => "The default ncurses attributes for echoed (typed by you, showed in the output window) text.",
        :echo_colors => "The default ncurses colors for echoed (typed by you, showed in the output window) text.",
        :trace_attributes => "The default ncurses attributes for messages shown under trace loglevel.",
        :trace_colors => "The default ncurses colors attributes for messages shown under trace loglevel.",
        :debug_attributes => "The default ncurses attributes for messages shown under debug loglevel.",
        :debug_colors => "The default ncurses colors attributes for messages shown under debug loglevel.",
        :info_attributes => "The default ncurses attributes for messages shown under info loglevel.",
        :info_colors => "The default ncurses colors attributes for messages shown under info loglevel.",
        :warn_attributes => "The default ncurses attributes for messages shown under warn loglevel.",
        :warn_colors => "The default ncurses colors attributes for messages shown under warn loglevel.",
        :error_attributes => "The default ncurses attributes for messages shown under error loglevel.",
        :error_colors => "The default ncurses colors attributes for messages shown under error loglevel.",
        :flush => "Whether to display every char we get as soon as there is a pause in the transfer or a newline.
In contrast to only displaying the input characters when there is a newline.",
        :gags => "The gags. All lines from the server are checked against these regular expressions.
If any one matches that line will not be shown. Note that if you have flush == true, the characters may already have been shown.",
        :remote_substitutions => "The remote substitutions. 
The same buffer that the remote_triggers work on will be searched for matches to the keys in this hash.
All values to matching keys will replace the keys in the buffer.",
        :local_substitutions => "The local substitutions.
The text you send to the server will be searched for matches to the keys in this hash.
All values to matching keys will replace the keys in the text.",
        :anti_gags => "The anti gags. 
If flush == false the lines matching these regular expressions will be shown as soon as they are matched.
A line matching an anti gag and a gag will also be shown.",
        :shutdown_triggers => "The shutdown triggers. Code in this array will be run in order at shutdown.",
	:connect_triggers => "The connect triggers. Code in this array will be run in order when a connection is made.",
	:disconnect_triggers => "The disconnect triggers. Code in this array will be run in order when a connection is closed.",
        :startup_triggers => "The startup triggers. Code in this array will be run in order after the windows have been properly initialized.",
        :remote_triggers => 'The remote triggers.
Each line received from the server will be checked against all regular expression keys in this hash, 
and all values to matching keys will be executed with three parameters: the input window, the output window and the match object.
Only if the return value of this execution is not false will the line be shown to the user.
Example: conf.remote_triggers[/^You feel dazed$/] = Proc.new do |inwin, outwin, match| inwin.set_status_message("dazed") end',
        :remote_character_triggers => 'The remote character triggers.
All input from the server is added to a buffer that is cleared on newline and each time a new character is added to that buffer the buffer will be checked against all the regular expression keys in the remote_character_triggers.
All code values belonging to matching keys will be executed with three parameters: the input window, the output window and the match object.
Example: conf.remote_character_triggers[/^(\S+) attacks you$/] = Proc.new do |inwin, outwin, match| inwin.send("kill #{match[1]}") end',
        :local_triggers => 'The local triggers.
Every line that is to be sent to the server is matched against the regular expression keys in this hash before they are sent.
All code values belonging to matching keys will be executed with three parameters: the input window, the output window and the match object.
Only if the return value of this execution is not false will the line be sent to the server.
Example: conf.local_triggers[/^bp (\S+)$/] = Proc.new do |inwin, outwin, match| inwin.send("put #{match[1]} in backpack") end',
        :key_commands => 'The key commands.
Each key pressed will have its keycode checked against the integer keys of this hash.
If no key match and the keycode is below 256, the character corresponding to this code will be appended to the input line.
If a key matches the value in the hash will be checked.
If the value is another hash a new key will be waited for, and the same procedure will take place with the value hash instead.
If the value is not a hash it will be executed as code with three parameters: the input window, the output window and the matching key.
Example: conf.key_commands[65] = Proc.new do |inwin, outwin, char| inwin.echo("I just pressed A") end',
        :userdir => 'The user directory. All *.rb files in this directory will be loaded on startup and on reload_application!
The root of the user directory takes precidence over (overrides) sub-directories.
Symbolic links (files and directories) are also used.
Directories beginning with a period are ignored.',
        :history_file => 'The file where we will store the history of entered commands.',
        :output_buffer => 'The number of rows that will be buffered in the output window for scrollback.',
        :input_height => 'The number of rows in the input window.',
        :input_logfile => 'The IO object that will receive everything we receive from the remote end.',
        :output_logfile => 'The IO object that will receive everything we send to the remote end.'
      }
    end
  end

end
