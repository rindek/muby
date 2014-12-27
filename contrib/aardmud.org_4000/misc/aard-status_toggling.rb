conf.local_triggers[/^afk(.*)/] = Proc.new do |inqin, outwin, match| afk match[1..-1] ; false end

def afk(string)
  # Remove the space at the beginning of the string.
  string = ensure_s(string)
  case string
  when "" then
    # TODO: spit out a random tagline.  =)
    if $afk == 0 then
      write "afk #{$afk_message}"
      $afk = 1
    else # $afk != 0
      # go unafk
      write "afk"
    end
  when "0", 0 then
    if $afk == 1 then write "afk" end
    $afk = 0
  when "1", 1 then
    if $afk == 0 then write "afk" end
    $afk = 1
#   # IDEA: This can be enhanced to have shortcuts like this:
#   when "sleeping" then
#     if $afk == 1 then write "afk" end
#     write "afk I am sleeping.."
#     $afk = 1
  else
    # If already in afk, then exit afk mode to be able to change the message cleanly
    if $afk == 1 then write "afk" end
    # Toggle AFK mode.  This will either go afk with an optional message, or go unafk.
    write "afk #{string}"
    # toggle afk:
    if $afk == 1 then $afk = 0 else $afk = 1 end
  end
end



#
# autotick
#
# Auto-heal:
conf.remote_triggers[/^You will be informed when the mud 'ticks'\.$/]     = Proc.new do $autotick = 1 end
conf.remote_triggers[/^You will be not informed when the mud 'ticks'\.$/] = Proc.new do $autotick = 0 end
conf.remote_triggers[/^--> TICK <--$/] = Proc.new do
  if $autotick == 0
  then
    $autotick = 1
    autotick 0
  end
end

conf.local_triggers[/^autotick (.*)\n$/m] = Proc.new do |inwin, outwin, match| autotick match[1] ; false end

def autotick(c)
  c = ensure_c(c)
  case c
  when "0", 0 then
    if $autotick == 1
      write "autotick"
    end
    $autotick = 0
  when "1", 1 then
    if $autotick == 0
      write "autotick"
    end
    $autotick = 1
  else
    pprint "parameters other than 0 or 1 simply toggle the state"
    if c == "1" or c == 1 then
      autotick 0
    else
      autotick 1
    end
  end
end


#
# Sleep modification, to regenerate faster.
#
# Remember that 'sleep' is a Ruby command to pause for a certain length of time.
# it might be cool to automatically go invisible when I go to sleep, but then I'd have to take into account lfinger.
# add in: if no argument alongside this, then drop a bed if I have one.
# boots don't change regeneration rate anymore.  haste/lightspeed probably don't either.
# TODO: make a sleep alias that will set $asleep, maybe modify the prompt.  Maybe remove the "You go to sleep." comment the mud sends.
# deal with being woken up because of a fight? because of poison?
def wake ; asleep 0 ; false end
conf.remote_triggers[/^You go to sleep\.$/]        = Proc.new do $asleep = 1 end
conf.remote_triggers[/^You go to sleep on .*\.$/]  = Proc.new do $asleep = 1 end
conf.remote_triggers[/^You cannot sleep on .*\.$/] = Proc.new do $asleep = 1 ; wake end
conf.remote_triggers[/^You wake and stand up\.$/]  = Proc.new do $asleep = 0 end
# Furniture
conf.remote_triggers[/^You wake up from .* and stand up\.$/] = Proc.new do $asleep = 0 end
conf.remote_triggers[/^You are already standing\.$/]         = Proc.new do $asleep = 0 end

conf.local_triggers[/^sleep(.*)$/] = Proc.new do |inwin, outwin, match| asleep match[1..-1] ; false end
conf.local_triggers[/^wake$|^stand$/] = :wake

def _sleep_prep
  autotick 1
end
def _sleep_wake
  invis 0
  autotick 0
end

def asleep(string)
  string = ensure_s(string)
  if $afk == 1 then afk 0 end

  case string
  when "0", 0
    if $asleep == 1 then
      if $furniture == "" then
        write "wake"
      else
        write "wake;get #{$furniture};put #{$furniture} #{$bag}"
      end
      _sleep_wake
    else
      # pprint "already awake"
      # p
    end
    $asleep = 0
  when "1", 1
    if $asleep == 0 then
      _sleep_prep
      if $furniture != "" then
        write "get #{$furniture} #{$bag};drop #{$furniture};sleep #{$furniture}"
      else
        write "sleep"
      end
      $asleep = 1
    else
      # pprint "already sleeping"
      # p
    end
  else
    if $asleep == 0 then
      if string != "" then
        _sleep_prep
        # if a parameter other than 0 or 1 is passed, try to sleep on that object:
        write "sleep #{string}"
        # Set this, because the auto-heal cannot catch sleep failure.
        $asleep = 1
      else
        # if no parameter is passed, just sleep:
        asleep 1
      end
    else
      # pprint "already sleeping"
      # p
    end
  end
end
