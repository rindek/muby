#
# Newbie area speedwalks
#

# These areas are geared to new players, levels 1-50.
# This includes include shop areas.

# Getting to Aylor.  This is useful for people who use weird idle spots, portals or clanhalls:
# Aylor is the default home.  Type "recall" to get there.
# Advanced players will want to re-define these:
def _aylor ; recall ; $area = "Aylor" end
def recall ; write "recall" end
def _midgaard ; write "echo 'Midgaard' is now called 'Aylor'" ; _aylor end

# Art of Melody
def _artofmelody ; recall ; run "2s5ws;dance" ; $area = "Art of Melody" end

# Child's Play
def _childsplay ; _north ; write "run 8nwn" ; $area = "Child's Play" end

# Hotel Orlando
def _hotelorlando ; recall ; run "2s10wn10w3n" ; $area = "Hotel Orlando" end

# Land of Legend
def _landoflegend
  _north
  write "echo to get inside:  buy ticket"
  write "echo then go north and:  say board"
  write "echo to step off:  give ticket conductor"
  write "run 2se"
  $area = "Land of Legend"
end

# Lowlands Paradise '96
# key (yellow visitors band) is attained by:
# ... the adventurersguild
# write "run 2nw2nw2d;open east;run e;open north;run n"
# kill dragon
# write "open south;run s;open east;run e"
# kill visitor
def _lowlandsparadise96 ; _north ; write "3nw" ; $area = "Lowlands Paradise '96" end
def _lowlands ; _lowlandsparadise96 end


# Sen'nare Lake
def _sennarrelake ; _north ; write "run 10n7ws" ; $area = "Sen'nare Lake" end
def _sennarre ; _sennarrelake end
def _senarre ; _sennarrelake end
def _sennare ; _sennarrelake end
def _senare ; _sennarrelake end

# The Adventurers Guild
def _theadventurersguild ; recall ; write "run u" ; $area = "The Adventurers Guild" end
def _adventurersguild ; _theadventurersguild end

# The Amusement Park
def _theamusementpark ; _west ; write "run 3n2w4n19wn" ; $area = "The Amusement Park" end

# The Forest of Li'Dnesh
def _theforestoflidnesh ; _north ; write "run 9n5e" ; $area = "The Forest of Li'Dnesh" end
def _lidnesh ; _theforestoflidnesh end

# Gallows Hill
def _gallowshill ; recall ; invis 1 ; write "run 33s2e3s" ; $area = "Gallows Hill" end

# The Goblin Path
# The bear is aggro.
def _thegoblinpath ; _north ; write "run 15ne;open north" ; invis 1 ; $area = "The Goblin Path" end
def _goblinpath ; _thegoblinpath end

# The Infestation
def _theinfestation ; _north ; write "run 4nen" ; $area = "The Infestation" end
def _infestation ; _theinfestation end

# The Land of the Beer Goblins
def _thelandofthebeergoblins ; _angorbridge ; run "3w3sw" ; $area = "The Land of the Beer Goblins" end
def _beergoblins ; _thelandofthebeergoblins end

# The Land of the Fire Newts
def _thelandofthefirenewts ; _north ; write "run 8n10e" ; $area = "The Land of the Fire Newts" end
def _firenewts ; _thelandofthefirenewts end

# The Orchard
def _theorchard ; _east ; run "e2n" ; $area = "The Orchard" end
def _orchard ; _theorchard end

# The Rats Lair
def _theratslair ; recall ; write "run 13s2wsd" ; invis 1 ; $area = "The Rats Lair" end
def _ratslair ; _theratslair end

# Tournament Camps
def _tournamentcamps ; recall ; run "27se" ; $area = "Tournament Camps" end

# The Wobbly Woes of Woobleville
# stupid pamplet is given if one is not invis.
def _thewobblywoesofwoobleville ; _north ; invis 1 ; write "run 13n2e5n" ; $area = "The Wobbly Woes of Woobleville" end
def _woobleville ; _thewobblywoesofwoobleville end
def _wooble ; _thewobblywoesofwoobleville end
