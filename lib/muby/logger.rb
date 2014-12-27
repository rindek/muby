#
# A simple logger that logs to whatever logfiles you have defined
# in your preferences.
#
module Muby::Logger

  include Muby::Configurable
  
  #
  # Logs everything that gets read from the remote connection.
  #
  def log_input(c)
    if conf.input_logfile
      conf.input_logfile.write(c)
      conf.input_logfile.flush
    end
  end

  #
  # Logs everything that gets sent to the remote connection.
  #
  def log_output(c)
    if conf.output_logfile
      conf.output_logfile.write(c)
      conf.output_logfile.flush
    end
  end
end # module Logger
