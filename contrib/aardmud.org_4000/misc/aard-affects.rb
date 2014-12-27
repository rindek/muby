#
# Affects-script
#
# Intelligently spellup and skillup.  Self-only.

# TODO: Adapt to make it workable on others.  Do it the easy way.. and get bunches of "you cannot cast this on another.." (gag that message..)
#   check out "spells spellup other"
# TODO: Provide intelligent exceptions.  i.e. if intertial barrier is on, don't try to cast protection good.
#       This should be easy to implement.

# To make it efficient, it only works with the names of the spells (and not the number).  This works very well when looking at saffects, casting the spell of that name, or removing an existing spell from the array of spell to be cast.


# TODO: Gag saffects to reduce spam?

# IDEA: I could count the number of spells/skills which need to be used.  I could even generate a progress bar on-screen or in the status bar!
# Maybe I could make an ETA for the spellup.. that'd be neat.

def autospellup(b)
  b = ensure_b(b)
  if b == true then
    if $autospellup == false then $autospellup = true ; pprint " # Autospellup is now on" end
  elsif b == false then
    if $autospellup == true then $autospellup = false ; pprint " # Autospellup is now off" end
  end
end

def f11
  autospellup true
end
def shift_f11
  autospellup false
end

def f12 ; _spellup end

def _affects_cleanup
  # Automatically re-attempt spells if one of them fails during casting (i.e. "lost concentration")
  $recasting = false
  conf.remote_triggers.delete(/^You can already see invisible\.$/)
  conf.remote_triggers.delete(/^You don't have enough mana to cast .*\.$/)
  conf.remote_triggers.delete(/^You are not affected by any skills or spells\.$|^You are affected by \d+ skill(|s) and \d+ spell(|s)\.$/)
  conf.remote_triggers.delete(/^You lost your concentration while trying to cast/)
  conf.remote_triggers.delete(/^You don't have enough .*\.$|^A powerful force quenches your magic\.|You can\'t concentrate enough\.$/)
  conf.remote_triggers.delete(/^You are already protected\.$|^You can already /)
  conf.remote_triggers.delete(/^ \* Recasting\.\.\.$/)
  conf.gags.delete('^You are affected by the following:$')
  conf.gags.delete('^You are affected by \d+ skill(s|) and \d+ spell(s|)\.$')
  conf.gags.delete('^ * Recasting...')
  conf.gags.delete('^Spell: ')
  conf.gags.delete('^Skill: ')
  # All the variables automatically get destroyed when all of this is complete.
end
# On load, clean things up.. just in case:
_affects_cleanup


#Just in case something goes wonky:
conf.local_triggers[/^aff$/] = Proc.new do
  _affects_cleanup
  write "aff"
  false
end
conf.local_triggers[/^saff$/] = Proc.new do
  _affects_cleanup
  write "saff"
  false
end


# Automatically discover what spellup spells you have access to:
# Example: _affects_build_array("spellup") will create the $spells_spellup array.
# NOTE: Do not run this multiple times back-to-back!
# TODO: Fix this so that the code is more universal (do that '$' + foo + bar trick)
def _affects_build_array(type)
  pprint " # Building an array from spells #{type}"
  # Gag the output of the list.  It's rough, but it works.
  conf.remote_triggers[/^Level: /] = Proc.new do
    conf.gags << '.*'
    # NOTE: There is no safe way to gag the dashed line and extended help.. something has to un-gag everything.
  end
  # ACTION
  conf.remote_triggers[/^(Level:\s+\d+ |\s+)(.*)Mana:.*\d+.*Learned:\s+(\d+)% \(.*\)$/] = Proc.new do |inwin, outwin, match|
    # IDEA: In theory, I could capture the entire list.. and put it all into a multi-dimensional array.. boy would that be tough.
    #    ([level, spell name, learned], [level, spell name, learned])
    # Any spellup spells which are learned over 60% will be considered:
    if match[3].to_i > 60 then
#       pprint match[2].rstrip.downcase.inspect
      case type
        when "spellup" then $spells_spellup << match[2].rstrip.downcase
        when "healing" then $spells_healing << match[2].rstrip.downcase
        when "combat"  then $spells_combat  << match[2].rstrip.downcase
      end
    end
  end
  # TEARDOWN
  conf.remote_triggers[/^-----------------------------------------------------------------------$/] = Proc.new do
    conf.remote_triggers.delete(/^(Level:\s+\d+ |\s+)(.*)Mana:.*\d+.*Learned:\s+(\d+)% \(.*\)$/)
    conf.remote_triggers.delete(/^-----------------------------------------------------------------------$/)
    conf.gags.delete('.*')
    conf.remote_triggers.delete(/^Level: /)
    case type
      when "spellup" then
        $spells_spellup.uniq!
        if $spells_spellup == nil then pprint "you don't have any spellup spells!" end
      when "healing" then
        $spells_healing.uniq!
        if $spells_healing == nil then pprint "you don't have any healing spells!" end
      when "combat"  then
        $spells_combat.uniq!
        if $spells_combat == nil then pprint "you don't have any combat spells!" end
    end
  end

  # SETUP
  case type
    when "spellup" then $spells_spellup = []
    when "healing" then $spells_healing = []
    when "combat" then $spells_combat  = []
  end
  write "spells #{type}"
end # _affects_build_array


# Copy this method to your user scripting, and you can remove or add affects.
def _affects_extras
#   $spells.delete("underwater breathing")
#   $skills << "clanskill"
end

def _spellup
  if $spells_spellup == nil then pprint "healing this routine.." ; _affects_build_array("spellup") ; return nil end

  afk 0
  asleep 0
  # Prevent multiple simultaneous recasts.  $recasting is unset by recast_cleanup
  # This is to stop dumbasses like me from double-tapping their spellup hotkey.
  if $recasting == true then pprint "## I'm already recasting!" ; return nil ; end
  $recasting = true

  # $spells_spellup is automatically populated on startup and levelup.
  $spells = $spells_spellup.dup
  $skills = []
  # User scripting to add/remove spells from $spells and $skills :
  _affects_extras
  $spells = $spells.uniq
  $skills = $skills.uniq
  # Based on saffects, learn what I'm affected with and remove them from the array of possibilities.
  _affects_qualify_array

  # SETUP:
  # Avoid seeing the entire list spammed every time.
  conf.gags << '^You are affected by the following:$'
  conf.gags << '^You are affected by \d+ skill(s|) and \d+ spell(s|)\.$'
  # I don't know why the $ at the end won't work..
  conf.gags << '^ * Recasting...'
  conf.gags << '^Spell: '
  conf.gags << '^Skill: '
  # Stuff attained from permanent items don't appear in saffects anymore.. =(
  conf.remote_triggers[/^You can already see invisible\.$/] = Proc.new do $spells.delete("detect invis") end
  conf.remote_triggers[/^You don't have enough mana to cast .*\.$/] = Proc.new do $spells.clear end
  # FIXME: Handle all the spells individually, and just remove the spell from the array and continue on with the other spells..
  # protection good, protection evil, FIXME
  conf.remote_triggers[/^You are already protected\.$|^You can already /] = Proc.new do $spells.clear end
#   conf.remote_triggers[/^You can already see magic\.$/] = Proc.new do $spells.delete("detect magic") end
  conf.remote_triggers[/^You are not affected by any skills or spells\.$|^You are affected by \d+ skill(|s) and \d+ spell(|s)\.$/] = Proc.new do
    # ACTION:
    _affects_act_on_array
  end

  write "saffects"
end

# Catch the output of "saffects", and remove spells from $spells_spellup
def _affects_qualify_array
  # When the saffects list has been displayed, clean up:
  conf.remote_triggers[/^-----------------------------------------------------------------------$/] = Proc.new do
    conf.remote_triggers.delete(/^Spell: (.*) \(.*\)$/)
    conf.remote_triggers.delete(/^Skill: (.*) \(.*\)$/)
    conf.remote_triggers.delete(/^-----------------------------------------------------------------------$/)
  end
  # Spells:
  conf.remote_triggers[/^Spell: (.*) \(.*\)$/] = Proc.new do |inwin, outwin, match|
#     pprint "Working with spell: #{match[1]}"
    $spells.delete(match[1])
  end
  # Skills:
  conf.remote_triggers[/^Skill: (.*) \(.*\)$/] = Proc.new do |inwin, outwin, match|
#     pprint "Working with skill: #{match[1]}"
    $skills.delete(match[1])
  end

  if $spells.include?("protection evil") then $spells_spellup.delete("protection good") end
  if $spells.include?("protection good") then $spells_spellup.delete("protection evil") end
  # TODO: That other spell which conflicts with these..

  # anything cast on me has been removed from the arrays
  # The arrays are now lists of spells which I _don't_ have.
end # _affects_qualify_array

def _affects_act_on_array
  # Spell failures will get re-inserted back into the spells array.
  conf.remote_triggers[/^You lost your concentration while trying to cast (.+)\.$/] = Proc.new do |inwin, outwin, match|
    $spells << match[1].downcase
  end

  # Prevent infinite recasting loops:
  conf.remote_triggers[/^You don't have enough .*\.$|^A powerful force quenches your magic\.|You can\'t concentrate enough\.$/] = Proc.new do
    $spells.clear
  end

  # Upon completion:
  conf.remote_triggers[/^ \* Recasting\.\.\.$/] = Proc.new do
#     pprint $spells.inspect
    if $spells == [] then
      write "echo @C * @WRecasting is complete.@w"
      _affects_cleanup
    else
      _affects_cleanup
      _spellup
    end
  end
#   pprint $spells.inspect
  $spells.each_index { |i|
    pprint "Spell: #{$spells[i]}"
    case $spells[i]
    # Exceptions:
    # TODO: Integrate my exceptions list:
    when "example" then
      write "echo example"
    else
      write "cast '#{$spells[i]}'"
      $spells.delete $spells[i]
    end
  }
#   pprint $skills.inspect
  $skills.each_index { |i|
    pprint "Skill: #{$skills[i]}"
    case $skills[i]
    # Exceptions:
    # TODO: Integrate my exceptions list:
    when "example" then
      write "echo example"
    else
      write "#{$skills[i]}"
      $skills.delete $skills[i]
    end
  }
  # Get the server to tell me when I've completed spamming all the skills and spells:
  # It would be nice if this were avoidable.. but I don't see a way unless I have the scripting understand what spells have what messages, and have it listen for the last message.  That'd be annoying to script.
  write "echo @C * @WRecasting...@w"
end ; # _affects_act_on_array
