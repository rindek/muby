#
# Learn from the score
#
# conf.local_triggers[/^score$/] = :score

def score
  conf.remote_triggers[/^\| Strength     : \[(.+)\/(.+)\] \| Race : (.+)\| Practices    : \[(.+)\] \|$/] = Proc.new do |inwin, outwin, match|
    $str_now = match[1].lstrip.to_i
    $str_max = match[2].rstrip.to_i
    $race    = match[3].rstrip
    $pracs   = match[4].lstrip.rstrip.to_i
  end
  conf.remote_triggers[/^\| Intelligence : \[(.+)\/(.+)\] \| Class: (.+)\| Trains       : \[(.+)\] \|$/] = Proc.new do |inwin, outwin, match|
    $int_now = match[1].lstrip.to_i
    $int_max = match[2].rstrip.to_i
    $class   = match[3].rstrip
    $trains  = match[4].lstrip.rstrip.to_i
  end
  conf.remote_triggers[/^\| Wisdom       : \[(.+)\/(.+)\] \| Sex  : (Male|Female).+\| Trivia       : \[(.+)\] \|$/] = Proc.new do |inwin, outwin, match|
    $wis_now = match[1].lstrip.to_i
    $wis_max = match[2].rstrip.to_i
    $sex     = match[3]
    $trivia  = match[4].lstrip.rstrip.to_i
  end
  conf.remote_triggers[/^\| Dexterity    : \[(.+)\/(.+)\] \| Level: (.+) \| Quest points : \[(.+)\] \|$/] = Proc.new do |inwin, outwin, match|
    $dex_now = match[1].lstrip.to_i
    $dex_max = match[2].rstrip.to_i
    # If my level has changed, then reload
    # TODO: Don't print this warning on startup..
    if match[3].rstrip.to_i + ($tier * 10) != $level then pprint " # Warning: Your level has changed.  Consider running /_reload" end
    $level   = match[3].rstrip.to_i + ($tier * 10)
    $qps     = match[4].lstrip.rstrip.to_i
  end
  conf.remote_triggers[/^\| Constitution : \[(.+)\/(.+)\] \|                   \| Quest time   : \[(.+)\] \|$/] = Proc.new do |inwin, outwin, match|
    $con_now = match[1].lstrip.to_i
    $con_max = match[2].rstrip.to_i
    # $qtimer is also learned through the prompt/bprompt:
    $qtimer  = match[3].lstrip.rstrip.to_i
  end
  conf.remote_triggers[/^\| Luck         : \[(.+)\/(.+)\] \|                   \|                          \|$/] = Proc.new do |inwin, outwin, match|
    $luc_now = match[1].lstrip.to_i
    $luc_max = match[2].rstrip.to_i
  end
  conf.remote_triggers[/^\| Hit    : \[(.+)\/(.+)\] \| Hitroll  : \[(.+)\] \| Weight :(.+)of(.+)\|$/] = Proc.new do |inwin, outwin, match|
    $hit_now    = match[1].lstrip.to_i
    $hit_max    = match[2].rstrip.to_i
    $hitroll    = match[3].lstrip.rstrip.to_i
    $weight_now = match[4].lstrip.rstrip.to_i
    $weight_max = match[5].lstrip.rstrip.to_i
  end
  conf.remote_triggers[/^\| Mana   : \[(.+)\/(.+)\] \| Damroll  : \[(.+)\] \| Items  :(.+)of(.+)\|$/] = Proc.new do |inwin, outwin, match|
    $mana_now  = match[1].lstrip.to_i
    $mana_max  = match[2].rstrip.to_i
    $damroll   = match[3].lstrip.rstrip.to_i
    $items_now = match[4].lstrip.rstrip.to_i
    $items_max = match[5].lstrip.rstrip.to_i
  end
  conf.remote_triggers[/^\| Moves  : \[(.+)\/(.+)\] \| Wimpy    : \[(.+)\] \| Pos    : (.+)\|$/] = Proc.new do |inwin, outwin, match|
    $mv_now   = match[1].lstrip.to_i
    $mv_max   = match[2].rstrip.to_i
    $wimpy    = match[3].lstrip.rstrip.to_i
    $position = match[4].lstrip.rstrip
    if $position == "Sleeping" then $asleep = 1 end
    if $position == "Standing" then $asleep = 0 end
  end
  conf.remote_triggers[/^\| Gold   : \[(.+)\] \| Saves    : \[(.+) \] \| Align  : (.+)\s+(\w+)\s+\|$/] = Proc.new do |inwin, outwin, match|
    $gold      = match[1].lstrip.rstrip.to_i
    $sv        = match[2].rstrip.to_i
    $align     = match[3].lstrip.rstrip.to_i
    $alignment = match[4].lstrip.rstrip
  end
  conf.remote_triggers[/^\| Exp    : \[(.+)\] \| Age      : \[(.+)\] \| Hunger :(.+)\/(.+)\((\w+)\)\s*\|$/] = Proc.new do |inwin, outwin, match|
    $exp           = match[1].lstrip.rstrip.to_i
    $age           = match[2].lstrip.rstrip.to_i
    $hunger        = match[3].lstrip.rstrip.to_i
    $hunger_max    = match[4].lstrip.rstrip.to_i
    $hunger_status = match[5]
  end
  conf.remote_triggers[/^\| To Lvl : \[(.+) \] \| Hours    : \[(.+)\] \| Thirst : (\d+)\s+\((\w+)\)\s+\|$/] = Proc.new do |inwin, outwin, match|
    $tnl           = match[1].lstrip.rstrip.to_i
    $hours         = match[2].lstrip.rstrip.to_i
    $thirst        = match[3].lstrip.rstrip.to_i
    $thirst_status = match[4]
  end
  conf.remote_triggers[/^\| Pierce : (.+) \((.+)\) \[.+\]\|$/] = Proc.new do |inwin, outwin, match|
    $ac_pierce        = match[1].lstrip.rstrip.to_i
    $ac_pierce_status = match[2].lstrip.rstrip
  end
  conf.remote_triggers[/^\| Bash   : (.+) \((.+)\) \[.+\]\|$/] = Proc.new do |inwin, outwin, match|
    $ac_bash        = match[1].lstrip.rstrip.to_i
    $ac_bash_status = match[2].lstrip.rstrip
  end
  conf.remote_triggers[/^\| Slash  : (.+) \((.+)\) \[.+\]\|$/] = Proc.new do |inwin, outwin, match|
    $ac_slash        = match[1].lstrip.rstrip.to_i
    $ac_slash_status = match[2].lstrip.rstrip
  end
  conf.remote_triggers[/^\| Exotic : (.+) \((.+)\) \[.+\]\|$/] = Proc.new do |inwin, outwin, match|
    $ac_exotic        = match[1].lstrip.rstrip.to_i
    $ac_exotic_status = match[2].lstrip.rstrip
  end



  @tmp = 1
  conf.remote_triggers[/^\+-------------------------------------------------------------------------\+$/] = Proc.new do
    conf.gags << '.*'
    # All of this should fire off on the bottom border of 'score':
    if @tmp == 2 then
#       pprint    $str_now.inspect
#       pprint    $str_max.inspect
#       pprint       $race.inspect
#       pprint      $pracs.inspect
#       pprint    $int_now.inspect
#       pprint    $int_max.inspect
#       pprint      $class.inspect
#       pprint     $trains.inspect
#       pprint    $wis_now.inspect
#       pprint    $wis_max.inspect
#       pprint        $sex.inspect
#       pprint     $trivia.inspect
#       pprint    $dex_now.inspect
#       pprint    $dex_max.inspect
#       pprint      $level.inspect
#       pprint        $qps.inspect
#       pprint    $con_now.inspect
#       pprint    $con_max.inspect
#       pprint     $qtimer.inspect
#       pprint    $luc_now.inspect
#       pprint    $luc_max.inspect
#       pprint    $hit_now.inspect
#       pprint    $hit_max.inspect
#       pprint    $hitroll.inspect
#       pprint $weight_now.inspect
#       pprint $weight_max.inspect
#       pprint   $mana_now.inspect
#       pprint   $mana_max.inspect
#       pprint    $damroll.inspect
#       pprint  $items_now.inspect
#       pprint  $items_max.inspect
#       pprint     $mv_now.inspect
#       pprint     $mv_max.inspect
#       pprint      $wimpy.inspect
#       pprint   $position.inspect
#       pprint       $gold.inspect
#       pprint         $sv.inspect
#       pprint      $align.inspect
#       pprint  $alignment.inspect
#       pprint        $exp.inspect
#       pprint        $age.inspect
#       pprint     $hunger.inspect
#       pprint    $hunger_max.inspect
#       pprint $hunger_status.inspect
#       pprint        $tnl.inspect
#       pprint      $hours.inspect
#       pprint     $thirst.inspect
#       pprint $thirst_status.inspect
#       pprint        $ac_pierce.inspect
#       pprint $ac_pierce_status.inspect
#       pprint          $ac_bash.inspect
#       pprint   $ac_bash_status.inspect
#       pprint         $ac_slash.inspect
#       pprint  $ac_slash_status.inspect
#       pprint        $ac_exotic.inspect
#       pprint $ac_exotic_status.inspect

      conf.remote_triggers.delete(/^\| Strength     : \[(.+)\/(.+)\] \| Race : (.+)\| Practices    : \[(.+)\] \|$/)
      conf.remote_triggers.delete(/^\| Intelligence : \[(.+)\/(.+)\] \| Class: (.+)\| Trains       : \[(.+)\] \|$/)
      conf.remote_triggers.delete(/^\| Wisdom       : \[(.+)\/(.+)\] \| Sex  : (Male|Female).+\| Trivia       : \[(.+)\] \|$/)
      conf.remote_triggers.delete(/^\| Dexterity    : \[(.+)\/(.+)\] \| Level: (.+) \| Quest points : \[(.+)\] \|$/)
      conf.remote_triggers.delete(/^\| Constitution : \[(.+)\/(.+)\] \|                   \| Quest time   : \[(.+)\] \|$/)
      conf.remote_triggers.delete(/^\| Luck         : \[(.+)\/(.+)\] \|                   \|                          \|$/)
      conf.remote_triggers.delete(/^\| Hit    : \[(.+)\/(.+)\] \| Hitroll  : \[(.+)\] \| Weight :(.+)of(.+)\|$/)
      conf.remote_triggers.delete(/^\| Mana   : \[(.+)\/(.+)\] \| Damroll  : \[(.+)\] \| Items  :(.+)of(.+)\|$/)
      conf.remote_triggers.delete(/^\| Moves  : \[(.+)\/(.+)\] \| Wimpy    : \[(.+)\] \| Pos    : (.+)\|$/)
      conf.remote_triggers.delete(/^\| Gold   : \[(.+)\] \| Saves    : \[(.+) \] \| Align  : (.+)\s+(\w+)\s+\|$/)
      conf.remote_triggers.delete(/^\| Exp    : \[(.+)\] \| Age      : \[(.+)\] \| Hunger :(.+)\/(.+)\((\w+)\)\s*\|$/)
      conf.remote_triggers.delete(/^\| To Lvl : \[(.+) \] \| Hours    : \[(.+)\] \| Thirst : (\d+)\s+\((\w+)\)\s+\|$/)
      conf.remote_triggers.delete(/^\| Pierce : (.+) \((.+)\) \[.+\]\|$/)
      conf.remote_triggers.delete(/^\| Bash   : (.+) \((.+)\) \[.+\]\|$/)
      conf.remote_triggers.delete(/^\| Slash  : (.+) \((.+)\) \[.+\]\|$/)
      conf.remote_triggers.delete(/^\| Exotic : (.+) \((.+)\) \[.+\]\|$/)
      conf.gags.delete('.*')
      conf.remote_triggers.delete(/^\+-------------------------------------------------------------------------\+$/)
    end
    @tmp += 1
  end

  write "score"
  false
end

