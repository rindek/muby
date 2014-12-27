#
# Godlike block-gagging routines!
#

# Note, this stuff will make your ears bleed if you don't have proper $prompt1 and $prompt2 regexes set.  See aardwolf_helpers.rb

# Gag everything from now until the prompt.
# Note that triggers are still viable, even if they're gagged from the user's view.
# This is automatically undone by the prompt as n elapses.
def gag_blocks(n)
  n = ensure_n(n)
#   pprint "the next #{n} blocks will be deleted\n"
  $gag_blocks += n
  conf.gags << '^(.*)$'
  conf.anti_gags << $prompt1
  conf.anti_gags << $prompt2
  conf.anti_gags << $bprompt1
  conf.anti_gags << $bprompt2
end
$gag_blocks = 0
def ungag_blocks
  # Ungagging blocks:
#   if $gag_block == true then conf.gags.delete('^(.*)$') end
  if $gag_blocks > 0 then
    $gag_blocks -= 1
#     pprint "You have #{$gag_blocks} blocks left\n"
    if $gag_blocks == 0 then
      conf.gags.delete '^(.*)$'
      conf.anti_gags.delete $prompt1
      conf.anti_gags.delete $prompt2
      conf.anti_gags.delete $bprompt1
      conf.anti_gags.delete $bprompt2
    end
  end
end

# Gag n prompts
def gag_prompts(n)
  n = ensure_n(n)
#   pprint "the next #{n} prompts will be deleted\n"
  $gag_prompts += n
  conf.gags << $prompt1
  conf.gags << $prompt2
  conf.gags << $bprompt1
  conf.gags << $bprompt2
end
$gag_prompts = 0
def ungag_prompts
  if $gag_prompts > 0 then
    $gag_prompts -= 1
#     pprint "You have #{$gag_prompts} prompts left\n"
    if $gag_prompts == 0 then
      conf.gags.delete $prompt1
      conf.gags.delete $prompt2
      conf.gags.delete $bprompt1
      conf.gags.delete $bprompt2
    end
  end
end

# Gag absolutely everything, for n prompts.
# The n'th prompt will appear.
def gag_all(n)
  n = ensure_n(n)
  gag_blocks(n)
  conf.anti_gags.delete $prompt1
  conf.anti_gags.delete $prompt2
  conf.anti_gags.delete $bprompt1
  conf.anti_gags.delete $bprompt2
end

def ungag
  pprint "ungagging.."
  $gag_prompts = 0
  $gag_blocks = 0
  conf.gags.delete $prompt1
  conf.gags.delete $prompt2
  conf.gags.delete $bprompt1
  conf.gags.delete $bprompt2
  conf.anti_gags.delete $prompt1
  conf.anti_gags.delete $prompt2
  conf.anti_gags.delete $bprompt1
  conf.anti_gags.delete $bprompt2
  p
end

# Anti-gagging.  Useful for note-related things.
$disable_gags = []
$disable_gags_blocks = 0
def disable_gags_blocks(n)
#   pprint "disabling gags"
  $disable_gags = conf.gags
  conf.gags = []
  $disable_gags_blocks += n
end

# Note that this will overwrite any gags which were set up in the meantime.
def undisable_gags_blocks
  if $disable_gags_blocks > 0 then
    $disable_gags_blocks -= 1
#     pprint "You have #{$disable_gags_blocks} blocks left\n"
    if $disable_gags_blocks == 0 then
      if $gags_blocks != []
#         pprint "restoring gags"
        conf.gags = $disable_gags
        $disable_gags = []
      end
    end
  end
end


# Untested:
$disable_triggers = {}
$disable_triggers_blocks = 0
def disable_triggers_blocks(n)
#   pprint "disabling triggers"
  $disable_triggers = conf.remote_triggers
  conf.remote_triggers = {}
  conf.remote_triggers[$prompt1] = :undisable_triggers_blocks
  # Another essential:
  conf.remote_triggers[/You cannot .* while (afk|AFK)\.$/] = Proc.new do $afk = 1 ; afk 0 ; repeat_history end
  $disable_triggers_blocks += n
end

# Note that this will overwrite any triggers which were set up in the meantime.
def undisable_triggers_blocks
  if $disable_triggers_blocks > 0 then
    $disable_triggers_blocks -= 1
#     pprint "You have #{$disable_triggers_blocks} blocks left\n"
    if $disable_triggers_blocks == 0 then
      if $disable_triggers != {}
#         pprint "restoring triggers"
        conf.remote_triggers = $disable_triggers
        $disable_triggers = {}
      end
    end
  end
end


def disable_gags_and_triggers(n)
  disable_gags_blocks n
  disable_triggers_blocks n
  conf.remote_triggers[$prompt1] = Proc.new do
    undisable_gags_blocks
    undisable_triggers_blocks
  end 
  conf.remote_triggers[/\*\[AFK\]\*/] = conf.remote_triggers[$prompt1]
  # Doing this allows the reviving of the trigger which continues to read a note on the next board:
  conf.remote_triggers[/^Changed to board .* unread note(|s) for you on this board\.$/] = Proc.new do
    undisable_gags_blocks
    undisable_triggers_blocks
    write "note"
  end
end


__END__

Here are some gag examples:

conf.gags << '^There are few things in this world as breathtaking as the Aylorian skyline at dawn\.$'
conf.gags << '^The citizens of the world awaken to a new day\.$'
conf.gags << '^\w+ calls the justice of \w+ to strike \w+ foes!$'
conf.gags << '^\w+ directs a jet of Marbu poison from (\w|\W)+ sleeves\.$'
conf.gags << '^Waves of energy emanate from \w+\.'

You can delete gags like this:

conf.gags.delete '^Waves of energy emanate from \w+\.'

# Imm global-spam:
# Dirtworm's globalspam
conf.gags << '^\.::\. '

# Obyron's karaoke
conf.gags << '^:::.*(K|k)araoke.*:::$'

# Poker-spam
# I'd love to put "poker" in there, but it seems that this isn't always written..
conf.gags << '^\*\* .* \*\*$'
