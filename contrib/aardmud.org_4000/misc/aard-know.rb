#
# Knowledge-aid
#

# know <filename>             display the contents of the @file
# know <filename> -1          delete the last line
# know <filename> -2          delete the last two lines
# know <filename> <string>  append <string> to the @file
#   From the commandline, double-quotes aren't needed and are in fact ignored.


# TODO: Allow double-quotes from the commandline.  Somehow.  =/
# FIXME: This assumes read/write permissions on the directory and @files.

conf.local_triggers[/^know(.*)$/] = Proc.new do |inwin, outwin, match| know match[1..-1] ; false end
def know (string)
  string = string.join(' ').lstrip
  string = string.gsub("\"", "")
  string = string.split(' ')
#   pprint string.inspect

  # Get to the right working directory:
  begin
    Dir.chdir(ENV["HOME"] + "/mubyrc.d/aardwolf/knowledge/")
  # If the chdir fails (the directory does not exist), then make the chain of directories.
  rescue Errno::ENOENT
    if not File.exists?(ENV["HOME"] + "/mubyrc.d/aardwolf/knowledge/") then
      if not File.exists?(ENV["HOME"] + "/mubyrc.d/aardwolf/") then
        if not File.exists?(ENV["HOME"] + "/mubyrc.d/") then
          if not File.exists?(ENV["HOME"]) then
            pprint "ERROR: #{ENV["HOME"]} does not exist!"
            return false
          end
            Dir.mkdir(ENV["HOME"] + "/mubyrc.d/")
        end
        Dir.mkdir(ENV["HOME"] + "/mubyrc.d/aardwolf/")
      end
      Dir.mkdir(ENV["HOME"] + "/mubyrc.d/aardwolf/knowledge/")
    end
  end

  if string[0] == nil then
    # The non-portable version::  pprint `ls -al --sort=time --reverse ./`
    # Set up an empty hash:
    directory = {}
    Dir.glob("*.txt").each { |file|
      directory.merge!({file, File.stat(file).mtime})
    } ; nil
    directory = directory.sort {|a,b| a[1]<=>b[1]} ; nil
    directory.each_index { |i|
      pprint "#{directory[i][1]} \t #{directory[i][0]}"
    } ; nil
    return false
  end

  # Do I need the full working path?
  @file = File.join(Dir.pwd, string[0].downcase + ".txt")
#   @file = string[0] + ".txt"
#   pprint @file.inspect

  def make_output
    @output = []
    File.open(@file, 'r+').each { |line|
      @output << line.chomp
    }
  end

#   pprint string[1].inspect
  case string[1]
  when nil then
    # The non-portable version:: pprint `more #{@file}`
    pprint "Displaying #{@file}"
    File.open(@file, 'r+').each { |line|
      pprint line.chomp
    }
    return false
  when "-1" then
    # non-portable version:
    #   `sed '$d' "#{@file}" > temporary`
    #   `mv -f temporary #{@file}`
    make_output
    pprint "Removing the last line from #{@file}"
    if @output.length <= 1 then
      pprint "#{@file} has only one line.  Deleting it."
      File.delete(@file)
      return false
    end
    File.open(@file, 'w') { |f| # prepare @file for appending content
      # All of the output, from the first line to the second-last line.
      f.print(@output[0..-2].join("\n"))
      f.print("\n")
    } # @file is automatically closed
  when "-2" then
    # non-portable version:
    #   `sed 'N;$!P;$!D;$d' "#{@file}" > temporary`
    #   `mv -f temporary #{@file}`
    make_output
    pprint "Removing the last two lines from #{@file}"
    if @output.length <= 2 then
      pprint "#{@file} has one or two lines.  Deleting it."
      File.delete(@file)
      return false
    end
    File.open(@file, 'w') { |f| # prepare @file for appending content
      # All of the output, from the first line to the third-last line.
      f.print(@output[0..-3].join("\n"))
      f.print("\n")
    } # @file is automatically closed
  else
    # If @file doesn't exist, make an empty one:
    if File.exists?(@file) == false then
      File.open(@file, 'w+') do |f| # open @file for update
        f.print ""                 # write out nothing
      end
    end
    pprint "Appending to #{@file}"
    # The non-portable version:: pprint `echo #{Time.now} #{string[1..-1].join(' ')} >> #{@file}`
    File.open(@file, 'a') do |f| # prepare @file for appending content
      f.print(
        # the string without the first word:
        "#{Time.now} \t #{string[1..-1].join(" ")} \n"
      ) # insert the string
    end # @file is automatically closed
  end

  # Display (some of) the contents of @file:
  # The non-portable version :: pprint `tail #{@file}`
  make_output
  if @output.length > 9 then
    # If I have a big @file, just output the last 10 lines in it.
    @output[-10..-1].each { |i|
      pprint i
    }
  else
    # If I have a small @file, output it all
    @output.each { |i|
      pprint i
    }
  end

  if File.zero?(@file) == true then
    pprint "#{@file} is empty, deleting it."
    File.delete(@file)
  end
  # So that the alias does not spit the text out to the server:
  return false
end
