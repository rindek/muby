#
# Colour Code Echo
#
# cce("@R RED @r red @G GREEN @g green @B BLUE @b blue @C CYAN @c cyan @M MAGENTA @m magenta @Y YELLOW @y yellow @W WHITE @w white\n\n")
# It's magic, baby!

$cce_display_invalid_codes = true
def cce(source)

# TODO: If printing redundant normal / bold codes offends someone's sensibilities, I could extract the current colour code, and only display another colour code if it's different!
# I'd do it right now, but I'm not sure how that works.
# Style.extract(@outputWindow.outputBuffer)
def normal  ; $INPUTATTRIBUTES = Ncurses.const_get("A_NORMAL") end
def reset   ; normal ; $INPUTCOLORS = [Ncurses.const_get("COLOR_WHITE"), Ncurses.const_get("COLOR_BLACK")] end
def bold    ; $INPUTATTRIBUTES = Ncurses.const_get("A_BOLD") end
def red     ; color_codes_set("COLOR_RED")     end
def green   ; color_codes_set("COLOR_GREEN")   end
def blue    ; color_codes_set("COLOR_BLUE")    end
def cyan    ; color_codes_set("COLOR_CYAN")    end
def magenta ; color_codes_set("COLOR_MAGENTA") end
def yellow  ; color_codes_set("COLOR_YELLOW")  end
def white   ; color_codes_set("COLOR_WHITE")   end

def color_codes_set(ncurses_colour_code)
  $INPUTCOLORS = [Ncurses.const_get(ncurses_colour_code), Ncurses.const_get("COLOR_BLACK")]
end

# echon in colour
def echon_colour (string)
  # If I wasn't sent anything useful, then .. don't do anything useful:
  if string == nil || string == "" then return nil end

  oldStyle = Style.extract(@outputWindow.outputBuffer)
  style = Style.new($INPUTATTRIBUTES, $INPUTCOLORS[0], $INPUTCOLORS[1])
  @outputWindow.print([style, string, oldStyle])
end

def colour_codes_code(code)
  # If I wasn't sent anything useful, then .. don't do anything useful:
  if code == nil || code == "" then return nil end
  # Weird code requires brackets:
  if (code.kind_of? String) == false then return nil end
  # If someone passed me @x then just use x
  # Also, behave semi-sanely if passed a weird string length.  Make it a string, then use element #2
  if code.length > 1 then code = code.to_s[1,1] end

  # This could offend someone, since it sends "unnecessary" bold/normal codes:
  if code == code.upcase then bold else normal end

  # Work with the different flavours of colour:
  case code.downcase
  when "r" then red
  when "g" then green
  when "b" then blue
  when "c" then cyan
  when "m" then magenta
  when "y" then yellow
  when "w" then white
  when "@" then echon_colour "@"
  else # If an invalid colour code has been found
    if $cce_display_invalid_codes == true then echon_colour "@" + code end
  end
end



  # If I wasn't sent anything useful, then .. don't do anything useful:
  if source == nil || source == "" then return nil end

  # Debug:
#   echon "# " + source

  # Gather an array of all the interesting text.
  strings = []
  source.split(/@./).each { |element|
    strings << element
  }

  # Gather an array of all the interesting codes
  codes = source.scan(/@./)

# Debug:
# echo strings.inspect
# echo codes.inspect

  # If all strings are nil, then return the last colour code:
  if strings.nitems == 0 then colour_codes_code codes.compact.last end


  # Work with the two halves of my source text:
  strings.each_index { |i|
    echon_colour(strings[i])
    colour_codes_code(codes[i])
  }
end

def cce_test
  echo "echon_colour test:\n------------------\n"
  cce("@R RED @r red @G GREEN @g green @B BLUE @b blue @C CYAN @c cyan @M MAGENTA @m magenta @Y YELLOW @y yellow @W WHITE @w white\n\n")
  cce("@rred     @Rbold red\n")
  cce("@ggreen   @Gbold green\n")
  cce("@bblue    @Bbold blue\n")
  cce("@ccyan    @Cbold cyan\n")
  cce("@mmagenta @Mbold magenta\n")
  cce("@yyellow  @Ybold yellow\n")
  cce("@wwhite   @Wbold white\n")
  cce("A simple string can be passed.\n")
  cce("A single colour code can be passed.\n")
  cce("@w")
  cce("@@an at symbol\n")
  $cce_display_invalid_codes = true
  cce("An invalid code can be set to appear: @xan invalid code\n")
  $cce_display_invalid_codes = false
  cce("Or to be removed: @xinvalid code\n")
  cce("@r@rmultiple colour codes at the start\n")
  cce("@w\n")
  cce("multiple colour codes at the end@r@r")
  echo ""
  echon_colour "bleed test"
end
