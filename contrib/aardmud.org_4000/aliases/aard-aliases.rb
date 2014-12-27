#
# Aliases are "local triggers" which match against what you type at the keyboard.
#

#
# These are the ones most likely to annoy users.
#
# misc.
conf.local_triggers[/^donate (.*)$/]  = Proc.new do |inwin, outwin, match| write "gdonate #{ensure_s(match[1..-1])}" ; false end
# conf.local_triggers[/^newbie (.*)$/]  = Proc.new do |inwin, outwin, match| write "snewbie" + ensure_s(match[1..-1]) end
conf.local_triggers[/^rep (.*)$/]     = Proc.new do |inwin, outwin, match| write "reply #{ensure_s(match[1..-1])}" ; false end
conf.local_triggers[/^eval (.*)$/]    = Proc.new do |inwin, outwin, match| write "study #{ensure_s(match[1..-1])}" ; false end
conf.local_triggers[/^re$/] = Proc.new do write "replay" ; nil end


conf.local_triggers[/^getwear (.*)$/] = Proc.new do |inwin, outwin, match| getwear ensure_s(match[1..-1]) ; false end
conf.local_triggers[/^getdual (.*)$/] = Proc.new do |inwin, outwin, match| getdual ensure_s(match[1..-1]) ; false end
conf.local_triggers[/^retire (.*)$/]  = Proc.new do |inwin, outwin, match|  retire ensure_s(match[1..-1]) ; false end

# little aliases:
# So you can copy-and-paste easier:
# For when people cut-and-paste from within this scripting.
conf.local_triggers[/^write (.*)$/] = Proc.new do |inwin, outwin, match| write match[1..-1] ; false end

conf.local_triggers[/^openall$/] = Proc.new do open n;open e;open s;open w;open u;open d ; false end
conf.local_triggers[/^closeall$/] = Proc.new do close n;close e;close s;close w;close u;close d ; false end
conf.local_triggers[/^ca$/] = Proc.new do write "consider all" ; false end
# TODO: Allow a specific corpse name to be looted.
conf.local_triggers[/^lc$/] = Proc.new do write "get all corpse;sacrifice corpse" ; false end
conf.local_triggers[/^recall$/] = Proc.new do recall ; false end
conf.local_triggers[/^spring$/] = Proc.new do write "divining" ; false end
conf.local_triggers[/^reunite$/] = Proc.new do write "reunion" ; false end
# FIXME: / is intercepted by muby.
# conf.local_triggers[/^\/$/]     = Proc.new do recall ; false end

conf.local_triggers[/^curep(.*)$/] = Proc.new do |inwin, outwin, match| casting("cure poison", match[1]) ; false end
conf.local_triggers[/^cureb(.*)$/] = Proc.new do |inwin, outwin, match| casting("cure blindness", match[1]) ; false end
conf.local_triggers[/^prote(.*)$/] = Proc.new do |inwin, outwin, match| casting("protection evil", match[1]) ; false end
conf.local_triggers[/^uncurse(.*)$/] = Proc.new do |inwin, outwin, match| casting("remove curse", match[1]) ; false end

# set up the channels:
# because.. who can remember them?  =/
conf.local_triggers[/^ranger (.*)$/]  = Proc.new do |inwin, outwin, match| write "grapevine " + ensure_s(match[1..-1]) ; false end
conf.local_triggers[/^warrior (.*)$/] = Proc.new do |inwin, outwin, match| write "wardrums "  + ensure_s(match[1..-1]) ; false end
conf.local_triggers[/^cleric (.*)$/]  = Proc.new do |inwin, outwin, match| write "commune "   + ensure_s(match[1..-1]) ; false end
conf.local_triggers[/^psi (.*)$/]     = Proc.new do |inwin, outwin, match| write "telepathy " + ensure_s(match[1..-1]) ; false end
conf.local_triggers[/^psionic (.*)$/] = Proc.new do |inwin, outwin, match| write "telepathy " + ensure_s(match[1..-1]) ; false end
conf.local_triggers[/^thief (.*)$/]   = Proc.new do |inwin, outwin, match| write "cant "      + ensure_s(match[1..-1]) ; false end
conf.local_triggers[/^rogue (.*)$/]   = Proc.new do |inwin, outwin, match| write "cant "      + ensure_s(match[1..-1]) ; false end
conf.local_triggers[/^paladin (.*)$/] = Proc.new do |inwin, outwin, match| write "chant "     + ensure_s(match[1..-1]) ; false end
conf.local_triggers[/^mage (.*)$/]    = Proc.new do |inwin, outwin, match| write "inform "    + ensure_s(match[1..-1]) ; false end

def reload ; reload_application! ; false end
conf.local_triggers[/^reload$/] = :reload

# # identification assistance:
# conf.local_triggers[/^bid (.*)$|^rbid (.*)$|^id (.*)$|^c id (.*)$|^lore (.*)$/] = Proc.new do
#   id
#   afk 0
#   # Send the original string
#   true
# end

# Become invisible.  Good for speedwalks.
# To be customized by the user.
conf.local_triggers[/^invis (.*)$/] = Proc.new do |inwin, outwin, match| invis match[1] ; false end
def invis(w)
  w = ensure_w w
  case w
    when 0, "0", false, "false", "off", "remove" then invis_off
    when 1, "1", true,  "true",  "on",  "wear"   then invis_on
    else pprint "ERROR: 'invis' requires valid input.  You said: #{w}"
  end
end
def invis_on  ; pprint "become invisible" end
def invis_off ; pprint "become visible"   end
conf.local_triggers[/^vis$/] = Proc.new do vis ; false end
def vis ; write "visible" end


# conf.local_triggers[/^bp (\S+)$/] = Proc.new do |inwin, outwin, match| inwin.send("put #{match[1]} in backpack") end

# Walking through a locked door, then locking it behind you.
conf.local_triggers[/^oc (.*)$/] = Proc.new do |inwin, outwin, match| oc match[1] ; false end
def oc(c)
  c = ensure_c c
  def openclose(c, c2)
    c = ensure_c c
    c2 = ensure_c c2
#     write "open #{c} ; run #{c} ; close #{c2} ; lock #{c2}"
    open c ; run c ; close c2 ; lock c2
  end
  case c
    when n then openclose(n, s)
    when e then openclose(e, w)
    when s then openclose(s, n)
    when w then openclose(w, e)
    when u then openclose(u, d)
    when d then openclose(s, n)
    else pprint "ERROR: 'oc' requires a valid direction.  You said: #{c}"
  end
end



# A portal helper, to automatically get, use and return a portal from a container.
# This can be easily modified to have a default container, or to automatically re-wield or wear+hold.
conf.local_triggers[/^portal (.*)$/] = Proc.new do |inwin, outwin, match| portal(match[1], match[2]) ; false end

# Portal should be updated so that the procedure uses one parameter, and it cuts things apart to get $1 $2 etc, so that my procedures can use 1 or 2 parameters.
def portal(*string)
  gag_all 7
#   pprint portal + container
#   Muby::InputWindow.pprint(myportal + container)
  # I'd like to ensure_s(string[0]) etc, but it generates warnings!
  myportal  = string[0]
  container = string[1]
  if myportal == "" then return nil end
  if container == "" or container == nil then container = $bag end
  if container == "bag" then container = $bag end
  asleep 0
  afk 0
  if $dual != "" then dual "remove" end
  getfrom myportal, container
  hold myportal
  enter
  # TODO: if "You can't enter THAT", abort -- bounces.. etc.. ungh.
  write "remove #{myportal}"
  putin myportal, container
  if $dual != "" then dual $dual end
end



conf.local_triggers[/^door (.+)|gate (.+)$/] = Proc.new do |inwin, outwin, match|
   # TODO: Check class and level, and allow one spell to work like the other.. allow people to use either command..
  write "cast #{match}"
  false
end

$questing = false
def f5
  if $questing == false then
    pprint "Requesting a quest.."
    afk 0
    _questor
    gag_all 2
    write "quest request;quest info"
    # TODO: This should be based on a trigger:
    $questing = true
  else
    pprint "Completing this quest.."
    afk 0
    _questor
    gag_all 2
    write "quest complete"
    # TODO: This should be based on a trigger:
    $questing = false
  end
end


# kludge to fix 'p', while afk.
conf.local_triggers[/^p$/] = :p
def p
  if $afk == 1 then
    # TODO: I could gag the two strings:
    # AFK mode removed. There are no tells waiting for you.
    # You are now in AFK mode.
    # but damn that's annoying to do.
    afk 0
    afk 1
  else
    # I could also write \n
#     write "\n"
    write "p"
  end
  false
end

# make sure that note reading / writing works correctly:
# TODO: Highlight item descriptions.. especially if something is a clanned item:
# | Clan Item  : From The Hook Clan                                 |
conf.local_triggers[/^note(.*)$/] = Proc.new do
  # Remove all gags and triggers until I get the prompt or afk:
  disable_gags_and_triggers 1
  # write out whatever I typed:
  true
end
# TODO: Implement an external editor.. or I could even implement an inline Ruby editor which is intelligent about line-wrapping..
#   nohup kedit [mmucl rc_dir]/_note.temp&
# # exec xterm -e nohup kwrite [mmucl rc_dir]/_note.temp\&
# }



# # Quest request:
# You ask Questor for a quest.
# Questor tells you 'You're very brave SySy, but let someone else have a chance.'
# Questor tells you 'Come back later.'

# # Quest complete
# You inform Questor that you have completed your quest.
# Questor tells you 'You're not on a quest right now SySy.'
# Questor tells you 'You still have to wait 23 minutes to request one.'
