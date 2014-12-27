
# Put the prompts above and below the text area.
# TODO: What about double?
# TODO: List statuses, like afk/invis/regen.
# in combat, qmob, highlighting
# TODO: colour the directions: north = blue, east = green, south = red, west = yellow, up = white, down = grey
# TODO: colour the alignment, hp/mp/vp
# NOTE: The downside of all of this is that your scrollback buffer does not have the gags anymore.
# If all of this is too cpu-intensive, then it can be very easily simplified.
$spinner = "|"
$doublexp = 0
$leader_hp = 0
def update_statuses
  # Affix the compasspoints in a specific place in the direction-field.
  directions = "      "
  if $directions =~ /N/ then directions[0] = "N" end
  if $directions =~ /E/ then directions[1] = "E" end
  if $directions =~ /S/ then directions[2] = "S" end
  if $directions =~ /W/ then directions[3] = "W" end
  if $directions =~ /U/ then directions[4] = "U" end
  if $directions =~ /D/ then directions[5] = "D" end
  alignment = $alignment[0..0] # Just the first char.
  align = (
      " " * (           5 - $align.to_s.size)  + $align.to_s
    )
  tnl       = " " * (           4 - $tnl.to_s.size)    + $tnl.to_s
  qtimer    = " " * (           2 - $qtimer.to_s.size) + $qtimer.to_s
  hp_now    = " " * ($hp_max.size - $hp_now.size)      + $hp_now.to_s
  mp_now    = " " * ($mp_max.size - $mp_now.size)      + $mp_now.to_s
  vp_now    = " " * ($vp_max.size - $vp_now.size)      + $vp_now.to_s
  doublexp = (
    if $doublexp > 0 then ">> Double: #{$doublexp} "
    else ""
    end
    )
  leader_hp = (
    if $leader_hp > 0 then ">> Leader: #{$leader_hp} hp "
    else ""
    end
    )
  enemy_hp = (
    if $enemy_hp > 0 then ">> Enemy: #{$enemy_hp}% "
    else ""
    end
    )
  $spinner = (
  case $spinner
    when "|"  : "/"
    when "\\" : "|"
    when "-"  : "\\"
    when "/"  : "-"
  end
  )

  Muby::InputWindow.get_instance.set_status_line("#{$spinner}[#{directions}]#{align} (#{alignment}) / #{tnl}tnl / #{qtimer} quest / #{$tells} tells #{doublexp}")
  Muby::InputWindow.get_instance.set_message_line(" #{hp_now} / #{$hp_max} hp, #{mp_now} / #{$mp_max}m, #{vp_now} / #{$vp_max}v #{leader_hp}#{enemy_hp}")
  Muby::InputWindow.get_instance.update
  # This guarantees that the prompt will never reappear:
  if $gag_prompts == 0 then
    gag_prompts 1
    $gag_prompts += 1
  else
    $gag_prompts += 1
  end
end
