#
# Void trigger.  The character will never disconnect because of timeouts.
#
# NOTE: returning from the void causes your character to stand, and it does not influence your AFK status.
# However, voiding and coming back doesn't wake one up.
conf.remote_triggers[/^You disappear into the void\.$/] = Proc.new do |inwin, outwin, match|
  # It's best to turn it off, to avoid unpleasantness.
  afk 0
  # NOTE: Cannot echo while afk.
  if $asleep == 1 then wake end
  write "echo keepalive -- #{Time.new}"
  afk '@YF@Wear @YT@Whe @YV@Woid@Y.@w'
end

conf.remote_triggers[/^QUEST: You may now quest again.$/] = Proc.new do
  p
  # Play music?
end
conf.remote_triggers[/^You see no one here but yourself!$/] = Proc.new do write "map" end

# Do the obvious thing, when reading notes.
conf.remote_triggers[/^Changed to board .+ unread note(|s) for you on this board\.$/] = Proc.new do write "note" end

# 'this command', 'whatever', 'ftalk', etc... =/
conf.remote_triggers[/^\*\[AFK\]\* |^You are now in AFK mode\.$/] = Proc.new do $afk = 1 end
conf.remote_triggers[/You cannot .+ while (afk|AFK)\.$/] = Proc.new do $afk = 1 ; afk 0 ; repeat_history end

# When completed a note, get the prompt so that triggers and gags will resume.
# Note cancelled!
conf.remote_triggers[/You are back in the game\.$/] = :p


conf.remote_triggers[/^Better stand up first\.$/] = Proc.new do write "stand" ; repeat_history end
conf.remote_triggers[/^Nah\.\.\. You feel too relaxed\.\.\.$/] = Proc.new do write "stand" ; repeat_history end
# Push fails for no particular reason.  Keep trying:
conf.remote_triggers[/^You don\'t quite feel up to pushing things around at the moment\.$/] = Proc.new do repeat_history end

# Commands while sleeping.  Like 'snore'  =/
conf.remote_triggers[/^In your dreams\, or what\?/]    = Proc.new do $asleep = 1 ; wake ; repeat_history end
conf.remote_triggers[/^You dream about being able to/] = Proc.new do $asleep = 1 ; wake ; repeat_history end


# TODO: I don't know if the "intelligence" here actually works yet.
def repeat_history
#   pprint Muby::InputWindow.get_instance.history[-1]
#   pprint Muby::InputWindow.get_instance.history[-2]
  # If the first character is a slash, then abort!
  if Muby::InputWindow.get_instance.history[-1].split(' ')[0][0..0] == "/" then pprint "not doing #{Muby::InputWindow.get_instance.history[-1].split(' ')[0].inspect}\n" ; return nil end
  # Avoid throwing out something which will send me to recall..
  case Muby::InputWindow.get_instance.history[-1].split(' ')[0]
  # Don't leak a "know" string to the mud!
  when "know" then return nil
  # Let me do /repeat_history manually:
  when "/repeat_history" then
    case Muby::InputWindow.get_instance.history[-2].split(' ')[0]
    when "know" then return nil
    else
      write Muby::InputWindow.get_instance.history[-2]
    end
  else
    write Muby::InputWindow.get_instance.history[-1]
  end
end

# Remember where I am:
conf.remote_triggers[/^You are in area : (.+)$/] = Proc.new do |inwin, outwin, match| $area = match[1].rstrip end

conf.remote_triggers[/^You have been KILLED!!$/] = Proc.new do write "stand" end
# Untested..
conf.remote_triggers[/^\*\* For \w+'s interference, you can take revenge on \w+ for \d+ \w+.$/] = Proc.new do write "pkstats" end

# Santuary elapse/dispelled -- you could also echo it locally, or just replace the elapse message with something more visible.
conf.remote_triggers[/^Your brilliant white aura of sanctuary shimmers and is gone\.$/] = Proc.new do write "gtalk @C**@W My sanctuary is gone! @C**@w" end


# Search through triggers.
def rt_search(s)
  s = ensure_s(s)
  conf.remote_triggers.each { |i|
    if i.inspect =~ /#{s}/ then pprint i.inspect end
  }
end
# Use with:  /rt_search "string"


# If I try to dual something, then note the dual attempt.
# NOTE: Variables are not saved between sessions yet.
# TODO: Do something similar with holding an item.
conf.local_triggers[/^dual (.+)$/] = Proc.new do |inwin, outwin, match|
  dual match[1]
  false
end
def dual(s)
  s = ensure_s(s)
  $dual_attempt = s
  write "dual '#{ensure_s(s)}'"
end
# If I successfully dual an item, then note the new dual item.
conf.remote_triggers[/^You wield .+ in your off-hand\.$/] = :_dual_success
def _dual_success
  if $dual_attempt == "" then return nil end
  # Intelligently Deal with #.keyword -- 2.axe 20.axe 200.axe etc  =)
  # NOTE: This does not deal with the problem of picking up another item with the same keyword, and the resulting stack issues.  I miss being able to remove an item and have it be on the top of the inventory stack.  =(
  def dual_attempt(n)
    n = ensure_n(n)
    dual_attempt = $dual_attempt[(n+1)..-1]
    # Put the item back on the top of the stack
    write "remove #{dual_attempt}"
    write "give #{$dual_attempt} self"
    # Re-dual the item without the #.keyword:
    dual dual_attempt
  end
  if $dual_attempt[1..1] == "." then dual_attempt(1) end
  if $dual_attempt[2..2] == "." then dual_attempt(2) end
  if $dual_attempt[3..3] == "." then dual_attempt(3) end
  $dual = $dual_attempt.dup
  $dual_attempt = ""
end

# TODO: Don't know how to use..
# TODO: Barely know how to use..
conf.remote_triggers[/^You are not carrying that!$|^That really wouldn\'t make a very effective weapon\.$|^You must be level .+ to use .+\.$/] = :_dual_fail
def _dual_fail
  if $dual_attempt != "" then $dual_attempt = "" end
end

conf.remote_triggers[/^You raise a level!!$/] = :levelup

def levelup
  $level += 1
  write "wimpy"
  # TODO: Make this more noticible.
  pprint ">> level #{$level - ($tier * 10)} (#{$level})"

#   pprint "level #{$level} / 5 = #{$level / 5.0}"
#   pprint "      #{$level / 5.0} => #{($level / 5.0) - $level / 5}"
  # Every 5 levels, check my score.  This is primarily to get the new $wis_now
  if (($level / 5.0) - $level / 5) == 0.0 then score end
end


__END__

[ 10 minutes of double exp started courtesy of Aardwolf supporters - see 'help donate' ]


--+

The Aardwolf gamedriver tells you 'ACK!!! I'm in a loop.
--- Pfile saved. Qtime reset. Emergency reboot coming up ---

--+

What be thy name, adventurer?
<login>
The game is currently available only to imms.
This means that either Aardwolf is about to reboot, or, the mud has a
problem that can only be solved without players online.

 Please wait a few minutes and try again.
 Thanks for your patience and see you soon! - Immortals of Aardwolf.

--+

Reboot imminent. Quest time reset and full heal given.

-----------------------------------------------------------------------------
We hope you have enjoyed playing Aardwolf and will return soon. Please check
out our web site at www.aardwolf.com and maybe even drop in a vote for us
while you're there.
-----------------------------------------------------------------------------

--+

Someone forces you to 'quit quit'.
Reboot imminent. Quest time reset and full heal given.

-----------------------------------------------------------------------------
We hope you have enjoyed playing Aardwolf and will return soon. Please check
out our web site at www.aardwolf.com and maybe even drop in a vote for us
while you're there.
-----------------------------------------------------------------------------

--+



#
# Trigger group experimentation (fails)
#

--+ METHOD ONE:

groups = []
conf.remote_triggers[/^\| Names      : (.+)\|$/] = Proc.new do |inwin,
outwin, match|
 @names = match[1].rstrip
 groups << match[0]
end

then I could delete it with:
group.each { |i|
 conf.remote_triggers.delete(i)
}

However, match[0] is not what I want.  Is there a way to easily refer
to the regex itself?

--+ METHOD TWO

$trigger_groups = {}
def group_remote_trigger(group, regex, actions)
  conf.remote_triggers[regex] = Proc.new do |inwin, outwin, match| actions end
  $trigger_groups.merge!({group => regex})
  pprint $trigger_groups.inspect
end

def group_remote_trigger_delete_all(group)
  $trigger_groups[group].each { |i|
    pprint i.inspect
    conf.remote_triggers.delete(i)
    $trigger_groups.delete(group)
  }
end

# /group_remote_trigger("test", '^test$', {pprint match[0]})
# /group_remote_trigger_delete_all("test")
