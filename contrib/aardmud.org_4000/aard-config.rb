#
# Aardwolf settings:
#
# 1) Check your prompt
# 2) Check your battle prompt
# do:  alias y echo


#
# Muby overrides:
#
# conf.echo = false
# conf.user_edited_config_file = true

#
# Aardwolf scripting - user-defined settings.
#
# To make changes to any of these items, copy the line to your own scripting and change it there.  Remember that if you make changes in this file, your changes will be overwritten on the next muby update!

# The important stuff:
# TODO: Auto-detect this.
$tier = 0
# /rcc will automatically log you in, if you complete these:
# DO NOT SET THESE IF ANYONE ELSE HAS ACCESS TO YOUR COMPUTER AND YOUR MUBY SCRIPTING!
# $character_name             = "Name"      # /rc and /rcc
# $character_password         = "Password"
# $character_name_tester      = "Name"      # /rct
# $character_password_tester  = "Password"
# $character_name_builder     = "Name"      # /rcb
# $character_password_builder = "Password"


# FIXME:
# Automatically retry casting all failed spells.
$autospellup = false # press F11 to enable it.


def _affects_extras_clanskill
  # Define it in your user scripting.
  # $skills << "skillname"
end
def _affects_extras
  # Spells you don't want to bother re-casting all the time.
  $spells.delete("infravision")
  $spells.delete("underwater breathing")
  # Aardwolf Helm of True Sight:
  $spells.delete("true seeing")
  $spells.delete("detect invis")
  $spells.delete("detect hidden")
  $spells.delete("detect magic")
  $spells.delete("detect poison")
  $spells.delete("detect evil")
  $spells.delete("detect good")
  # Aardwolf Aura of Sanctuary:
  $spells.delete("sanctuary")
  # Wings of Aardwolf
  $spells.delete("fly")
  # NOTE: Boots of Aardwolf give haste, but casting haste gives additional dex.

  # TODO: Check for that other wacky protection spell.. cast things in the right order, or don't re-cast a redundant spell if I'm affected by it.
  case $alignment
  when "good"
    $spells.delete("protection good")
  when "evil"
    $spells.delete("protection evil")
  when "neutral"
    $spells.delete("protection good")
  else
    pprint "error with $alignment: #{$alignment.inspect}"
  end
  _affects_extras_clanskill
end

#
# Prompts and their companion regular expressions.
#

# To use this prompt, within aardwolf type this next line, without the # character at its start:
# prompt @w [%e] %a / %Xtnl / %q quest / %t tells %d%c %h / %Hhp, %m / %Mm, %v / %Vv @y> @w%c
# Prompts:
  # line 1
$prompt1 = '^ \[(\w+)\] (.*) \/ (\d+)tnl \/ (\d+) quest \/ (\d+) tells(.*)$'
  # line 2
$prompt2 = '^ (\d+) \/ (\d+)hp, (\d+) \/ (\d+)m, (\d+) \/ (\d+)v > $'

# To use this prompt, within aardwolf type this next line, without the # character at its start:
# bprompt @w [%e] %a / %Xtnl / %q q / %t t %d%c %h / %Hhp (%l%b)  %m / %Mm, %v / %Vv @y> @w%c
# Battle Prompts:
  # line 1
$bprompt1 = '^ \[(\w+)\] (.*) \/ (\d+)tnl \/ (\d+) q \/ (\d+) t(.*)$'
  # line 2
$bprompt2 = '^ (\d+) \/ (\d+)hp \( (.+)%\)  (\d+) \/ (\d+)m\, (\d+) \/ (\d+)v > $'


$afk_message = "@YS@Worry@Y, @YI A@Wm @YA@Wway@Y.@w"

$bag = "bag aardwolf"
# TODO: Figure out how to save this variable between states.  =/
if $dual == nil then $dual = "" end
if $furniture == nil then $furniture = "" end
$asleep = 0
$afk = 0
$autotick = 0
$portal = ""


#
# Hotkeys
#
# NOTE: If you have another kind of keyboard and need to use other settings, you can override all of this in your own scripting.  However, I would appreciate getting your list.  Then I could have a simple $keyboard_type = "US-104" or something..
conf.key_commands.merge({
  265=>:f1,
  266=>:f2,
  267=>:f3,
  268=>:f4,
  269=>:f5,
  270=>:f6,
  271=>:f7,
  272=>:f8,
  273=>:f9,
  274=>:f10,
  275=>:f11,
  276=>:f12,

  277=>:shift_f1,
  278=>:shift_f2,
  279=>:shift_f3,
  280=>:shift_f4,
  281=>:shift_f5,
  282=>:shift_f6,
  283=>:shift_f7,
  284=>:shift_f8,
  285=>:shift_f9,
  286=>:shift_f10,
  287=>:shift_f11,
  288=>:shift_f12,

  289=>:control_f1,
  290=>:control_f2,
  291=>:control_f3,
  292=>:control_f4,
  293=>:control_f5,
  294=>:control_f6,
  295=>:control_f7,
  296=>:control_f8,
  297=>:control_f9,
  298=>:control_f10,
  299=>:control_f11,
  300=>:control_f12,

  # Don't expect these to work!  Your window manager may not let these keys get to your terminal.
  313=>:alt_f1,
  314=>:alt_f2,
  315=>:alt_f3,
  316=>:alt_f4,
  317=>:alt_f5,
  318=>:alt_f6,
  319=>:alt_f7,
  320=>:alt_f8,
  321=>:alt_f9,
  322=>:alt_f10,
  323=>:alt_f10,
  324=>:alt_f12,

})

# At the keyboard, you can do crazy things like this:
# conf.key_commands[338] = :scroll_down!
# Or maybe:
# /conf.key_commands.merge({338=>:scroll_down!, 339=>:scroll_up!})

# # For reference, here are my key commands:
# conf.key_commands = {
# # up
#   259=>:previous_history_buffer!,
# # down
#   258=>:next_history_buffer!,
# # left
#   260=>:previous_character_buffer!,
# # right
#   261=>:next_character_buffer!,
# # control-left
#   515=>:previous_word_buffer!,
# # control-right
#   517=>:next_word_buffer!,
# # pageup
#   339=>:scroll_up!,
# # pagedown
#   338=>:scroll_down!,
# # Home
# #   27=>{91=>{49=>{126=>:home_buffer!}}},
# # End
# #   27=>{91=>{52=>{126=>:end_buffer!}}},
# # Backspace
#   127=>:backspace_buffer!,
# # unknown
# #   263=>:backspace_buffer!,
# # Delete
#   330=>:delete_buffer!,
# # unknown
# #   343=>:process_buffer!,
# # Enter (regular, or keypad)
#    10=>:process_buffer!,
# # Control-C
#     3=>:two_step_quit!,
# # Control-V
#    22=>:toggle_verbosity!,
# # F1 -- overridden later on.
# #   265=>:help,
# # tab
#   9 => :complete!,
# # ctrl-r
#   18 => :toggle_history_search!,
# 
#   27=>{91=>{
#     # home
#     49=>{126=>:home_buffer!},
#     # end
#     52=>{126=>:end_buffer!},
#     50=>{59=>{53=>{126=>:control_insert}}},
#   }}
# 
# }

def startup_routine
  # nothing defined
end
conf.startup_triggers << :startup_routine

# Customize this to go to your clanhall/manor:
def _questor
  recall
  write "run 8s"
end
