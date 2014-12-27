
module Muby

  module HelperMethods
    
    include Muby::Styled
    
    def execute(command, *args)
      execute_with_verbosity(:debug, command, *args)
    end

    def do_execute(command, *args)
      result = nil
      if command.respond_to?(:call)
        result = command.call(*args[0...(command.arity)])
      elsif String === command
        result = eval(command)
      elsif Symbol === command
        method = self.method(command)
        args = args[0...(method.arity)]
        result = method.call(*args)
      elsif Array === command
        method = self.method(command.first)
        args = (command[1..-1] + args)[0...(method.arity)]
        result = method.call(*args)
      else
        result = command
      end
      result
    end

    def execute_with_verbosity(verbosity, command, *args)
      begin
        result = do_execute(command, *args)
        unless result.nil?
          case result
          when String
            Muby::OutputWindow.get_instance.show(verbosity, result)
          else
            Muby::OutputWindow.get_instance.show(verbosity, result.inspect)
          end
        end
        result
      rescue SystemExit => ex
        quit
      rescue Exception => e
        exception(e)
      end
    end
    
  end

end
