# many vidblain area portals land you in a random room.
def _vidblain ; recall ; write "run 4ne;open n;run 2nw16n25e;enter hole" end

# All areas in Vidblain have randomly-placed entrances.  Use 'bigmap' (requires MCCP) to see entrances.

# Doom & Gloom
def _doomandgloom ; _unknown end

# The Darklight
def _darklight ; _unknown end
# from amulet of the plane;run 12e;enter pool;run 3n2end

# Dune: the Desert Planet
# TODO: SWs to the other good spots.
# FIXME: List the keys..
def _dune ; _unknown end
def _dunesietch
  _dune
  # this requires passdoor
  run "nd;enter spacecraft;run 2n;enter shuttle;run 3nd4ne3nenw2n"
end
def _dunecompound
  _dune
  run "nd;enter spacecraft;run 2n;enter shuttle;run 3nd4ne5nw2n"
  # this requires passdoor
end

# Galaxy
def _galaxy ; _unknown end

# Mega-City One
def _megacityone ; _unknown end

# Star Wars
#  Portal: dark crystal
#  Doorway Mobs: 'imperial recruit' (38) 'imperial weapons' (42)
def _starwars ; _unknown end
def _starwarsin
  _starwars
  invis 1
  run "e;open east;run 4en;open west;run w;open north;run 2n;enter portal"
end

# ST:TNG
def _sttng
  _unknown
  pprint "Warning:  This area is norecall noportal! =(  _sttngevil and _sttngexit exist"
end
def _sttngevil
  _sttng
  run "e2swe2n;open west;run w"
end
def _sttngexit
  write "open east;run e2swsne2nw;enter transport"
end
def _sttngferengi
  _sttng
  write "enter ferengi"
end
def _sttngklingon
  _sttng
  write "enter ferengi;run n;enter klingon"
end

# Ultima
# 5-50 []
# TODO: Add in some funky intelligence?  If I get there and I try the door and don't have the key, then SW to the mob which has it and wait for the player to kill it.  After the kill, set a hotkey to SW back.  It could work..
def _ultima ; _unknown end
def _ultima1 ; _ultima end
def _ultima_1 ; _ultima end
# Library
# FIXME: speedwalk -- bat north and east and up has the key to second
def _ultima2 ; run "3s;open up;run u" end
def _ultima_2 ; _ultima_1 ; run "3s;open up;run u" end
# Tavern
# FIXME: where? -- giant spider has the key for the third
def _ultima3 ; run "w3se;open south;run s;open up;run u" end
def _ultima_3 ; _ultima_2 ; run "w3se;open south;run s;open up;run u" end
# Courthouse
# FIXME: not sure who has the key to get to four
def _ultima4 ; run "sw;open down;run des;open up;run u" end
def _ultima_4 ; _ultima_3 ; run "sw;open down;run des;open up;run u" end
# FIXME: not sure who has the key to get to five
def _ultima5 ; run "2n;echo random, scan for 'The Yew Moongate' - might be 3e" end
def _ultima_5 ; _ultima_4 ; run "2n;echo random, scan for 'The Yew Moongate' - might be 3e" end
# FIXME: not sure who has the key to get to six
def _ultima6 ; run "unene;open up;run u" end
def _ultima_6 ; _ultima_5 ; write "echo then:  unene;open up;run u" end
