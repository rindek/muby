#
# Variable helpers
#
# This is so that you don't have to constantly put your terms in quotes.  So instead of run "n" you do run n.
# They could technically be made really smart, to return x or write x .. but even I'm not crazy enough to code that.

def n ; return "n" end
def s ; return "s" end
def e ; return "e" end
def w ; return "w" end
def u ; return "u" end
def d ; return "d" end
def cast(string) ; write "cast #{string}" end
def casting(spell, target)
  if target == "" then
    # Strangely, I can't specify "self" because some spells won't allow that parameter.
    write "cast '#{spell}'"
  else
    write "cast '#{spell}' #{target}"
  end
  nil
end


#
# Procedure helpers
#
# These exist, so that your scripting can do things like a person at the keyboard, without you having to use 'write' every time.  It's very handy for copying keyboard commands and pasting them into your scripting.
# examples:  run n;open e;close s;write "echo The server echos this";echo "only you see this"
# It's not quite perfect, because you need double-quotes around your text.. but it's good enough.

# run is housed in speedwalks_common.rb
# Remember that you use these like: open "one", "two"
#                     and NOT like: open "one" "two"
#
# Yes, I am paranoid enough to ensure against everything, even when write does it again.  =)
# Warning: 'open' is an internal Ruby command.  If you want to open files, use:  Kernel::open
def open(w)  ; write  "open #{ensure_w(w)}" end
def close(w) ; write "close #{ensure_c(w)}" end
def lock(w)  ; write  "lock #{ensure_c(w)}" end
def run(s)   ; write   "run #{ensure_s(s)}" end
# def get(s)   ; write    "get #{ensure_s(s)}" end
# I think something is strange with this one..
def put(s)   ; write   "put #{ensure_s(s)}" end
def get(s)   ; write   "get #{ensure_s(s)}" end
def take(s)  ; write  "take #{ensure_s(s)}" end
def buy(s)   ; write   "buy #{ensure_s(s)}" end
def say(s)   ; write   "say #{ensure_s(s)}" end
# Is this another magical Ruby keyword?
def scan(s)  ; write  "scan #{ensure_s(s)}" end

# Warning: 'enter' is reserved by Ruby.  If you want to 'enter', use:  Kernel::enter
# TODO: This needs testing.
def enter(*s)
  s = ensure_s(s)
  if s == "" then
    write "enter"
  else
    write "enter '#{s}'"
  end
end

# Aardwolf requires single quotes around multiple-word objects.
def wear(s)  ; write   "wear '#{ensure_s(s)}'" end
# This might be bugged somehow:
def remove(s); write "remove '#{ensure_s(s)}'" end
def wield(s) ; write  "wield '#{ensure_s(s)}'" end
def hold(s)  ; write   "hold '#{ensure_s(s)}'" end
def keep(s)  ; write   "keep '#{ensure_s(s)}'" end
def unkeep(s); write "unkeep '#{ensure_s(s)}'" end
def quaff(s) ; write  "quaff '#{ensure_s(s)}'" end
def dual(s)
  s = ensure_s(s)
  if s == "remove" then
    write "dual remove"
  else
    write "dual '#{s}'"
    # should really only set dual on success
    $dual = s
  end
end
def wield(s)
  s = ensure_s(s)
  if s == "remove" then
    write "wield remove"
  else
    write "wield '#{s}'"
    # should really only set wield on success
    $wield = s
  end
end

def getfrom(s, s2)  ; get "'#{ensure_s(s)}' '#{ensure_s(s2)}'" end
def putin(s, s2)    ; put "'#{ensure_s(s)}' '#{ensure_s(s2)}'" end

# with the bag:
def getbag(s); get "'#{ensure_s(s)}' '#{$bag}'" end
def putbag(s); put "'#{ensure_s(s)}' '#{$bag}'" end
def removebag(s); remove s ; putbag s end
def retire(s) ; removebag(s) end
def removebag_unkeep(s); remove s ; unkeep s ; putbag s end
def retire_unkeep(s) ; removebag_unkeep(s) end
def getwear(s)      ; getbag s ; wear s end
def getwear_keep(s) ; getbag s ; keep s ; wear s end
def getdual(s)      ; getbag s ; dual s end
def getdual_keep(s) ; getbag s ; keep s ; dual s end
def getquaff(s)     ; getbag s ; quaff s end
def geteat(s)       ; getbag s ; eat s end

# TODO: This has to be smarter..
# check for (item)
# Check for #, (item)
# check for #, (item name)
# def buyput(s, s2) ; write "buy #{s} '#{s2}' ; put all.#{s2} '#{$bag}'" end
# buy, then stuff things in the bag
# This can't deal with:  pocket 10, "jade elixir"
conf.local_triggers[/^pocket (.*)$/] = Proc.new do |inwin, outwin, match| pocket match[1..-1].to_s.split("\"") ; false end
def pocket_alias(s)
#   write s.inspect + "--"
#   write s[0].inspect + "0"
#   write s[1].inspect + "1"
  write "buy #{s[0].strip} #{s[1]};put all.#{s[1]} '#{$bag}'"
end
def pocket(s, s2)
  write "buy #{s} #{s2};put all.#{s2} '#{$bag}'"
end

# When writing out to the server, split separate commands with a semi-colon.
# This lets you do things like: write "run e;open d;d;cough"
# This has been fixed to work in all circumstances.. from methods, from methods called by triggers/aliases, from the commandline..
def write(string)
# Another method:
# def method_one
#   string = ensure_s(string)
#   # Split across any semi-colons.
#   string = string.split(';')
#   # Run through it, executing each command separately.
#   string.each_index { |i|
#     # Good for debugging.  Then you don't have to connect to anything to try most stuff out.
# #     Muby::InputWindow.get_instance.pprint string[i].lstrip + "\n"
#     Muby::InputWindow.get_instance.send string[i].lstrip
#   }
#   false
# end
# Also, a generic search/replace of ; for \n would work.

  # Leveraging muby's local substitution powers, I can do it this way:
  string = ensure_s(string)
  conf.local_substitutions[';'] = "\n"
  Muby::InputWindow.get_instance.send string
  conf.local_substitutions.delete ';'
end


#
# Internal helpers
#

# Ensure that a string is given.
def ensure_s(input)
  # TODO: Technically, I should check the type of whatever I'm being sent, and ensure that it's possible to convert it to a string.
  string = input.to_s.lstrip
  # This does not detect or respect numbers.  It returns them as type String.
  return string
end

# Ensure that a word is given.
# These helpers can probably be done more intelligently.
def ensure_w(input)
  string = ensure_s input
  if string.split(' ')[1] != nil then
    pprint "Warning: You should only send one word."
    word = string.split(' ')[0]
  else
    word = string
  end
  return word
end

# Ensure that a character is given.
def ensure_c(input)
  word = ensure_w(input)
  if word.length > 1 then
    pprint "Warning: You should only send one character."
  end
  character = word
  # This does not detect or respect a number.  It returns it as type String.
  return character
end

# Ensure that a character is given.
def ensure_n(input)
  if input.class != Fixnum then
    pprint "Warning: You should only send a number."
    # FIXME: This should rescue errors and react accordingly.
    number = input.to_i
  end
  number = input
  return number
end

# Ensure that a boolean value (true/false) is given.
def ensure_b(input)
  if input.class != TrueClass && input.class != FalseClass then
    pprint "Warning: You should only send a boolean value (true/false).  Returning false."
    return false
  end
  boolean = input
  return boolean
end



# Generate a random number from a range of integers.
#example:
#random(6 .. 10)
#=> an integer from 6, 7, 8, 9, 10
def random(r)
  # assume r is a range of integers first < last
  r.first + rand(r.last - r.first + (r.exclude_end? ? 0 : 1))
end

# Random float:
# TODO one day I could detect additional decimal places and deal with them.. but not today.
# example:
# random_f(1.0..2.2)
# => a float:  1.0, 1.1, 1.2 .. 2.0, 2.1, 2.2
def random_f(r)
  big = random((r.first * 10)..(r.last  * 10))
  big / 10.0
end

def prompt_routines
  $afk = 0
  ungag_blocks
  ungag_prompts
  undisable_gags_blocks
  undisable_triggers_blocks
end

# This is wrapped into something reusable, so that I can easily re-enable it when I do trigger-disabling.
def prompt_triggers_setup
  # Whenever you see the prompt, perform the appropriate routines:
  conf.remote_triggers[$prompt1]  = :prompt_routines
  conf.remote_triggers[$bprompt1] = :prompt_routines
end
prompt_triggers_setup


# I like doing it this way.. it seems to work out fairly well.
def pprint(s)
  Muby::InputWindow.get_instance.print(s.to_s + "\n").to_s
end

def _reload
  afk 0
  wake
  # I don't do 'invis 0' because I sometimes hang out in an aggro room and do scripting-work.. and I don't want to become visible and get into fights.. especially when half the client might not work.  =)
  autotick 0
  # Avoid disconnections:
  Thread.new do
    sleep 1
    score
    sleep 1
    _affects_build_array("spellup")
  end
end

def _startup
  afk 0
  wake
  invis 0
  autotick 0
  p
end


def connection_triggers
  conf.remote_triggers[/^Last on from|^Reconnecting\.\.\.\.$/] = Proc.new do
    _startup
    _reload
    conf.remote_triggers.delete(/^Last on from|^Reconnecting\.\.\.\.$/)
  end
end

def login_triggers(type)
  @name = eval('$' + 'character_name' + type)
  @pass = eval('$' + 'character_password' + type)
  if @name == nil || @pass == nil then return nil end
  conf.remote_triggers[/#############################################################################/] = Proc.new do
    write "#{@name};#{@pass};y"
    conf.remote_triggers.delete(/#############################################################################/)
  end
end

def rc
  # No compression:
  # TODO: This will eventually change to aardwolf.com
  # After playing for a bit, you should switch to port 4010
  connection_triggers
  login_triggers("")
  connect "aardmud.org", 4000
end
def rcc
  # Compression via MudProxy.
#   connect "127.0.0.1", 9009
  connection_triggers
  login_triggers("")
  connect "localhost", 9009
end
# Tester's Port.
# See also 'help tester', 'who tester'
def rct
  connection_triggers
  login_triggers("_tester")
  connect "builder.aardmud.org", 6555
end
# Builder's Port
# See also 'help builder'
def rcb
  connection_triggers
  login_triggers("_builder")
  connect "build.aardmud.org", 6000
end

# Repeat an action
# example:
# repeat("echo hi!", 3)
# TODO: Allow a method to be passed.
$repeat = {}
def repeat(action, times, echo)
  @echo = ensure_b(echo)
#   pprint action.inspect
  @action = ensure_s(action)
  # If sent nothing, do nothing.
  if @action == "" then return nil end
  times = ensure_n(times)
  # Throw this data into a hash, so that multiple uses of repeat will accumulate.. and the counting will work well..
  if $repeat[@action] == nil then
    $repeat[@action] = times
  else
    $repeat[@action] = $repeat[@action] + times
  end
  # Wrap it in a thread so you can do other stuff.
  Thread.new do
    until $repeat[@action] < 1
      # This is imperfect, since echo seems to bypass the action queue sometimes..
      # Be more friendly, and don't spam and possibly get disconnected:
      # TODO: Don't sleep on the very first action.. doesn't work.
#       if $repeat[@action] != times then sleep random_f(0.6..1.8) end
      sleep random_f(0.6..1.8)
      if $repeat[action] > 0 then
        if @echo == true then write "echo @w #{$repeat[@action]} - #{@action}" end
        write @action
        $repeat[@action] -= 1
      end
    end
  end
end

def highlight(string)
  string = ensure_s(string)
  conf.gags << string
  # This destroys the colour attributes of the entire line:
  conf.remote_triggers[/(.*)#{string}(.*)/] = Proc.new do |inwin, outwin, match|
#   Muby::Style.new(0, Ncurses.const_get("COLOR_RED"), :copy, true)
  # /pprint RED, "red"
  # /pprint Muby::Style.new(0, Ncurses.const_get("COLOR_RED"), :copy, true), "red"
  # But I can't get it to work down here! :
  # Ugly non-coloured "highlighting":
    pprint " > #{match[1]} #{string} #{match[2]}"
  end
end
def unhighlight(string)
  string = ensure_s(string)
  conf.gags.delete(string)
  conf.remote_triggers.delete(/(.*)#{string}(.*)/)
end

# Use it like this:
# Singular:
#   n = 1
#   pprint "you have #{n} item#{plural(n)}."
# Plural:
#   n = 0
#   pprint "you have #{n} item#{plural(n)}."
#   n = 10
#   pprint "you have #{n} item#{plural(n)}."
# IDEA: This could be made much smarter, if I passed the appropriate word to use..
def plural(n)
  if n > 1 || n == 0 then "s" end
end


# It just makes life easier..
def dagger  ; "dagger"  end
def axe     ; "axe"     end
def sword   ; "sword"   end
def whip    ; "whip"    end
def spear   ; "spear"   end
def halberd ; "halberd" end
def mace    ; "mace"    end

__END__

$cwd = ENV['HOME']
conf.local_triggers[/^!(.*)/] = Proc.new do |inwin, outwin, match| shell match[1..-1] ; false end

# TODO: Add globbing functionality.
def shell(*input)
  input = input.to_s.split(' ')
  input[0] = input[0]
#   input[0] = input[0][1..-1]
  command = input[0]
  parameters = input[1..-1].join(' ')

  case command
  when "cd"
    if input[1] != nil then
      old_cwd = $cwd
      $cwd = input[1]
      begin
        # Allows * in directory names.
        Dir.chdir(Dir.glob($cwd).join(' '))
        $cwd = Dir.getwd
      # Example on my computer:
      # Errno::ENOENT: No such file or directory - nothing
      rescue SystemCallError
        pprint "No such directory - " + input[1]
        $cwd = old_cwd
        Dir.chdir($cwd)
      end
  else
      $cwd = ENV['HOME']
      Dir.chdir($cwd)
      $cwd = Dir.getwd
    end
  else
    Dir.chdir($cwd)
    # This looks good, but feels dangerous.  =)
    Thread.new do
      pprint `#{input.join(' ')}`
    end
  end
  pprint $cwd + " >"
end


# Why doesn't any of this work anymore?!  =(
pprint (defined? $loaded).inspect
if (defined? $loaded) != "global-variable" then
  # muby has just been started.
  $loaded = true
  pprint "Loaded user files."
  $startup = true
  _startup
  _reload
else
  # muby is already running, and this script is being summoned.
  # Actions to perform after using /reload .. this ought to reset all self-awareness.
  pprint "Re-loaded user files."
  $startup = true
  _startup
end