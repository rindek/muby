
module Muby

  module Displayer

    def exception(e)
      error("#{e.class}: #{e.message}")
      debug(e.backtrace.join("\n"))
    end

    def trace(s)
      if Muby::OutputWindow.get_instance.ready?
        Muby::OutputWindow.get_instance.show(:trace, s)
      elsif Muby::Configuration.get.display?(:trace)
        puts s
      end
    end

    def debug(s)
      if Muby::OutputWindow.get_instance.ready?
        Muby::OutputWindow.get_instance.show(:debug, s)
      elsif Muby::Configuration.get.display?(:debug)
        puts s
      end
    end

    def info(s)
      if Muby::OutputWindow.get_instance.ready?
        Muby::OutputWindow.get_instance.show(:info, s)
      elsif Muby::Configuration.get.display?(:info)
        puts s
      end
    end

    def warn(s)
      if Muby::OutputWindow.get_instance.ready?
        Muby::OutputWindow.get_instance.show(:warn, s)
      elsif Muby::Configuration.get.display?(:warn)
        puts s
      end
    end

    def error(s)
      if Muby::OutputWindow.get_instance.ready?
        Muby::OutputWindow.get_instance.show(:error, s)
      elsif Muby::Configuration.get.display?(:error)
        puts s
      end
    end

    module_function :trace
    module_function :debug
    module_function :info
    module_function :warn
    module_function :error
    module_function :exception

  end

end
