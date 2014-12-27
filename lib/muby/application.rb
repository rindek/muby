
module Muby

  class Application

    include Muby::Configurable
    include Muby::Displayer

    def initialize
      
      #
      # Load all user files
      #
      conf.load_user_files!
      
      # Init all the ncurses magic.
      Ncurses.initscr
      Ncurses.raw
      Ncurses.keypad(Ncurses.stdscr, true)
      Ncurses.noecho
      Ncurses.refresh
      if Ncurses.has_colors?
        Ncurses.start_color
      end

      # initialize late (to enable changes from $RC_FILE)
      Muby::OutputWindow.get_instance.go
      Muby::InputWindow.get_instance.go

      #
      # Exit commands
      # If we die by normal death (control-C for example):
      #
      at_exit do
        begin
          conf.shutdown_triggers.each do |proc|
            Muby::InputWindow.get_instance.execute(proc)
          end
          Muby::InputWindow.get_instance.saveHistory
        rescue Exception => e
          exception(e)
          error("Sleeping 10 seconds before closing")
          sleep(10)
        ensure
          Ncurses.endwin
          puts "Exiting muby..."
        end
      end
      
      #
      # The main loop
      #
      begin
        Muby::InputWindow.get_instance.process
      rescue SystemExit => ex
        violentDeath = false
        raise ex
      rescue Exception => error
        exception(error)
        error("Sleeping 10 seconds before closing")
        sleep(10)
      end
    end
  end

end
