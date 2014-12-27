# Sanitize the mob keyword:
# A stupid-keyword!               => stupid
# An egg, with a bad attitude?!?! => egg
def _mob_keyword(s)
  mob = ensure_s(s)
  # Take the second word.  This handily removes "A, An, The, ..." and resolves many keyword issues ("large elemental" becomes "large") :
  mob = mob.split(" ")[-1]
  # Remove punctuation which won't normally be found in keywords anyways:
  mob = mob.gsub(/,|\'|\?|!/,"")
  # remove trailing s' :
  mob = mob.sub(/s$/,"")
  # Only use the first part of the word, before a hyphen.  Some mob keywords do include them, but many do not.
  mob = mob.split('-')[0]
  return mob.downcase
end

def pprint_mob_consider(message, mob, original)
  mob      = ensure_s(mob)
  original = ensure_s(original)
  # Print out a nice and tidy version..
  pprint "#{message}\t#{mob}#{" " * (12 - mob.length)}(#{original})"
end

#
# Substitutions to help with keywords and mob levels.
#

_c1 = "^You would stomp (.+) into the ground\.$"
conf.gags << _c1
conf.remote_triggers[_c1] = Proc.new do |inwin, outwin, match|
  mob = _mob_keyword(match[1])
  pprint_mob_consider("-4  -19 or more", mob, match[1])
end

_c2 = "^(.+) would be easy, barely worth breaking a sweat over\.$"
conf.gags << _c2
conf.remote_triggers[_c2] = Proc.new do |inwin, outwin, match|
  mob = _mob_keyword(match[1])
  pprint_mob_consider("-3  -9 to -19", mob, match[1])
end

_c3 = "^No Problem! (.+) is weak compared to you\.$"
conf.gags << _c3
conf.remote_triggers[_c3] = Proc.new do |inwin, outwin, match|
  mob = _mob_keyword(match[1])
  pprint_mob_consider("-2  -6 to -9", mob, match[1])
end

_c4 = "^(.+) looks a little worried about the idea\.$"
conf.gags << _c4
conf.remote_triggers[_c4] = Proc.new do |inwin, outwin, match|
  mob = _mob_keyword(match[1])
  pprint_mob_consider("-1  -2 to -6", mob, match[1])
end

_c5 = "^(.+) should be a fair fight!$"
conf.gags << _c5
conf.remote_triggers[_c5] = Proc.new do |inwin, outwin, match|
  mob = _mob_keyword(match[1])
  pprint_mob_consider(" 0  +2 to -2", mob, match[1])
end

_c6 = "^(.+) snickers nervously\.$"
conf.gags << _c6
conf.remote_triggers[_c6] = Proc.new do |inwin, outwin, match|
  mob = _mob_keyword(match[1])
  pprint_mob_consider(" 1  +2 to +3", mob, match[1])
end

_c7 = "^(.+) chuckles at the thought of you fighting"
conf.gags << _c7
conf.remote_triggers[_c7] = Proc.new do |inwin, outwin, match|
  mob = _mob_keyword(match[1])
  pprint_mob_consider(" 2  +3 to +8", mob, match[1])
end

_c8 = "^Best run away from (.+) while you can!$"
conf.gags << _c8
conf.remote_triggers[_c8]  = Proc.new do |inwin, outwin, match|
  mob = _mob_keyword(match[1])
  pprint_mob_consider(" 3  +8 to +16", mob, match[1])
end

_c9 = "^Challenging (.+) would be either very brave or very stupid\.$"
conf.gags << _c9
conf.remote_triggers[_c9] = Proc.new do |inwin, outwin, match|
  mob = _mob_keyword(match[1])
  pprint_mob_consider(" 4  +16 to +21", mob, match[1])
end


_c10 = "^(.+) would crush you like a bug!$"
conf.gags << _c10
conf.remote_triggers[_c10] = Proc.new do |inwin, outwin, match|
  mob = _mob_keyword(match[1])
  pprint_mob_consider(" 5  +21 to +32", mob, match[1])
end


_c11 = "^(.+) would dance on your grave!$"
conf.gags << _c11
conf.remote_triggers[_c11] = Proc.new do |inwin, outwin, match|
  mob = _mob_keyword(match[1])
  pprint_mob_consider(" 6  +32 to +41", mob, match[1])
end


_c12 = "^(.+) says \'BEGONE FROM MY SIGHT unworthy!\'$"
conf.gags << _c12
conf.remote_triggers[_c12] = Proc.new do |inwin, outwin, match|
  mob = _mob_keyword(match[1])
  pprint_mob_consider(" 7  +41 to +50", mob, match[1])
end

_c13 = "^You would be completely annihilated by (.+)!$"
conf.gags << _c13
conf.remote_triggers[_c13] = Proc.new do |inwin, outwin, match|
  mob = _mob_keyword(match[1])
  pprint_mob_consider(" 8  +50 and above", mob, match[1])
end


__END__

when replace is in.. then implement a timestamp for channels..


sub set -group combat {%s is not from around these parts. Attack with extreme caution.$} "\t\t\\1"
sub set -group combat "Not in this room.\n" "\t\t&"
sub set -group combat "I don't think %w would approve of that.\n" "pet? \t\t&"
sub set -group combat "But %s looks so cute and cuddly...\n" "pet \t\t&"
sub set -group combat "Don't even think about it.\n" "n/a \t\t&"
sub set -group combat "You see no one here but yourself!\n" "- [color & {bold green}]"
action set -group combat "You see no one here but yourself!" {write "map"}
sub set -group combat "No! You shall not be allowed to commit such a treacherous act!\n" "clanmob \t&"


sub set -group combat {^Nobody is attacking %w right now.$}   "  [color & {bold green}]"
sub set -group combat "\nYou rescue %w!"        "> [color & {bold green}]"
sub set -group combat {^You fail to rescue %w!$}      "- [color & {bold red}]"
sub set -group combat {^%w rescues you!$}       "* [color & {bold green}]"

sub set -group combat {^You switch targets and begin to attack %s!$}  "> [color & {bold green}]"
sub set -group combat {^But you're already attacking them!$}    "- [color & {bold yellow}]"
sub set -group combat {^You fail to switch targets to %s!$}   "- [color & {bold red}]"
# faerie fire
sub set -group combat {^%s is surrounded by a pink outline.$}   "> [color & {bold green}]"
# rip flesh
sub set -group combat {^%s flesh is ripped from %w body.$}    "> [color & {bold green}]"


#You can see again.
# flaming weapon flag
sub set -group combat {^%s blinded by smoke!$}      "* [color & {bold red}]"
sub set -group combat {^Your eyes tear up from smoke...you can't see a thing!$} "* [color & {bold red}]"
sub set -group combat {^%w's eyes are no longer burning.$}    "> [color & {bold green}]"
sub set -group combat {^The burning in your eyes fades!$}   "> [color & {bold green}]"
# dirt kicking, when trying to cureb
#You cannot cure your blindness.

sub set -group combat {^%w turns blue and shivers.$}      "* [color & {bold red}]"
# shivers and suffers.
sub set -group combat {^%w shivers and suffers.$}     "* [color & {bold red}]"
sub set -group combat {^You remove %w poison.$}     "> [color & {bold green}]"
sub set -group combat {^%w looks very ill.$}        "* [color & {bold red}]"
sub set -group combat {^You shiver and suffer.$}      "* [color & {bold red}]"


# Psionicist spell "Awe"
sub set -group combat {^%s is more curious of you than in awe!$}  "- [color & {bold red}]"
sub set -group combat {^%s laughs at your attempt to make peace.$}  "- [color & {bold red}]"
sub set -group combat {^%s looks calm enough already.$}   "  &"
sub set -group combat {^%s is in AWE of you!$}      "- [color & {bold green}]"


sub set -group combat {^%s is here, fighting YOU!}      "> [color & {bold red}]"

# Healing substitutions
# cure light
sub set -group combat {You feel slightly better!$}      "  [color & {bold green}]"
# cure serious
sub set -group combat {You feel much better!$}      "  [color & {bold green}]"
# cure critical
sub set -group combat {You feel somewhat better!$}      "  [color & {bold green}]"
# heal
sub set -group combat {A warm feeling fills your body.$}    "  [color & {bold green}]"
# natures touch
sub set -group combat {You feel the touch of nature healing your wounds!$}  "  [color & {bold green}]"

sub set -group combat {You are now fully healed.$}      "  [color & {bold white}]"

sub set -group combat {^You block %s way as %w attempts to flee.} "  [color & {bold green}]"
sub set -group combat {^%s is unaffected by your %s!}   "* [color & {bold red}]"

sub set -group combat {^After your treatment, %s is now as tame as a kitten!} "* [color & {bold green}]"
sub set -group combat {^They are already kitten like. They can become no tamer!}  "* [color & {bold green}]"
sub set -group combat {^Your attempt to tame %s fails. Now %w is very wild and very angry!!}  "* [color & {bold red}]"

# some thief ability
sub set -group combat {^%s falls to %w knees blinded.}    "> [color & {bold green}]"

# sub set -group combat {^You glow with energy as you absorb a sapphire dragon's soften.

sub set -group combat "%s screams and attacks!\n" "* [color & {bold red}]"




#Your armor starts to melt away. You feel less protected.
# what spell?

# summon with   yellow {some text}
# This does not respect global variables like $bag
#alias set yellow {yellow $0}
proc yellow {parameters} {echo [color $parameters {yellow}]}

#alias set boldyellow {boldyellow $0}
proc boldyellow {parameters} {echo [color $parameters {bold yellow}]}


# Clan member exiting the realm:
sub set -group pretty {CLAN: The winds of duality change, as %w departs to meditate on the concept of reality.} ""
action set -group gags {CLAN: The winds of duality change, as %w departs to meditate on the concept of reality.} {echo [color ">" {bright yellow}] [color "$1 has left." {green}]}

# Clan member entering the realm:
sub set -group pretty {CLAN: %w has returned from the depths of their meditation, to the realm of Tao.} ""
action set -group gags {CLAN: %w has returned from the depths of their meditation, to the realm of Tao.} {echo [color ">" {bright yellow}] [color "$1 has entered." {green}]}



# My speaking to the clan:
sub set -group pretty {You tell the CLAN: '%s'} ""
action set -group gags {You tell the CLAN: '%s'}  {echo [color "(Clan)" {bold white}] [color "SySy: '$1'" {yellow}]}


sub set -group pretty {^You lost your concentration while trying to cast %s.$}  "- [color & {bold red}]"
sub set -group pretty {^Your magic is blessed with the luck of %s!$}  "  [color & {bold green}]"
#A cockroach's leg is sliced from its dead body.
#You get 15 gold coins from the hacked corpse of a cockroach.
#Mota gives you 30 gold coins for your hacked corpse of a cockroach.

sub set -group pretty {Your concentration is now at its peak.$} "  [color & {bold green}]"


# not working:
sub set -group pretty {You feel less sick.$}        "> [color & {bold green}]"

# chill flag?
#Your muscles stop responding.

sub set -group pretty {^%w has lost %w link.$}      "* [color & {bold red}]"
sub set -group pretty {^%w has reconnected.$}       "* [color & {bold green}]"
sub set -group pretty {They aren't here.$}        "- [color & {bold green}]"







#sub set {*Spouse:} " # Spouse:"
#sub set {*Janna:} " # Janna:"
#sub set "^\[ Your spouse has entered the realm! \]*" " ## Janna has arrived"
#sub set "^\[ Your spouse has left the realm! \]*" " ## Janna has left"


# scry
#You feel as if you are being watched.


# Or dampening field
sub set -group pretty {^You feel a brief tingling sensation.$} "- [color & {bold red}] (dispel magic)"

sub set -group pretty {You carve the corpse into a complete mess! You need more practice.} "[color "-" {bold red}] & (skin failed)"




# Using regexp, gag the entire thing.
# Then intelligently pick it up and replace it.. with if/switch statements.

action set -group pretty -regexp "(Remort:|Multiclass Player:|Level)(.*)i(Gladiator|Armsmaster|battlemaster|Warlord|Liege|Veteran|Champion|Savage|General)" {
  echo Warrior
  echo $0 0
  echo $1 1
  echo $2 2
}



# (?i) doesn't work
# use i(thingy)

return ""

;TIER CLASSES
/def -p0 -F -mregexp -aBCcyan -t'^(Remort:|\[Multiclass Player:|Level) (.*)(?i)(gladiator|armsmaster|battlemaster|warlord|liege|veteran|champion|savage|general)(.*)' = /test substitute(replace({P3}, 'Warrior', {P0}))
/def -p0 -F -mregexp -aBCcyan -t'^(Remort:|\[Multiclass Player:|Level) (.*)(?i)(deacon|chaplain|prophet|saint|patriarch|cardinal|bishop|exorcist|crusader)(.*)' = /test substitute(replace({P3}, 'Cleric', {P0}))
/def -p0 -F -mregexp -aBCcyan -t'^(Remort:|\[Multiclass Player:|Level) (.*)(?i)(nightblade|rogue|spy|sharper|cutthroat|crimelord|stalker|prowler|godfather)(.*)' = /test substitute(replace({P3}, 'Thief', {P0}))
/def -p0 -F -mregexp -aBCcyan -t'^(Remort:|\[Multiclass Player:|Level) (.*)(?i)(sage|lich|wizard|warlock|magician|conjurer|seer|sorcerer|archmage)(.*)' = /test substitute(replace({P3}, 'Mage', {P0}))
/def -p0 -F -mregexp -aBCcyan -t'^(Remort:|\[Multiclass Player:|Level) (.*)(?i)(mystic|telepath|channeler|dreamwalker|psychic|mentalist|visionary|mindshifter|enlightened)(.*)' = /test substitute(replace({P3}, 'Psionicist', {P0}))
/def -p0 -F -mregexp -aBCcyan -t'^(Remort:|\[Multiclass Player:|Level) (.*)(?i)(protector|cavalier|slayer|defender|zealot|terminator|benefactor|holy blade|chosen)(.*)' = /test substitute(replace({P3}, 'Paladin', {P0}))
/def -p0 -F -mregexp -aBCcyan -t'^(Remort:|\[Multiclass Player:|Level) (.*)(?i)(pathseeker|beastmaster|tracker|wayfinder|woodsman|explorer|strider|scout|treehugger)(.*)' = /test substitute(replace({P3}, 'Ranger', {P0}))



# None of this fucking works.. it works in a note but not in real life:
sub set -group pretty "%s corpse %s" ""
# This makes everything else grey (the regular font)..
action set -group pretty "%s corpse %s" {
  echo "$1 [color corpse {red}] $2"
}


sub set -group pretty {^*Click*}  "- [color & {bold green}]"
sub set -group pretty {^You unlock %s with %s.} "- [color & {bold green}]"


return break
