# Angband
# may be interrupted by crystal hatchlings (use pass w/o trace)
# wolfriders are aggro, orcs assist same.
# going downstairs requires the key from upstairs in the chest.
def _angband ; _west ; write "run 2wn2wn4wn8wn14w21ws2nun2un2uwndn" ; $area = "Angband" end

# Arisian Realm
#Portal: a dolphin figurine
def _arisianrealm ; _west ; write "run 2wn2wn4wn8wn14w7w3n" ; $area = "Arisian Realm" end
def _arisian ; _arisianrealm end

# Artrificer's Mayhem
def _artificersmayhem ; _west ; write "run 2wn2wn4wn8wn14w2w20s9wn" ; $area = "Artrificer's Mayhem" end
def _artificer ; _artificersmayhem end
def _arti ; _artificersmayhem end
def _artiin
  _artificersmayhem
  run "nw4ne;open north;run nwd2s"
end

# Avian Kingdom
# Doormobs: stratus
def _aviankingdom ; _west ; write "run 2wn2wn4wn8wn14w2w16s5ws" ; $area = "Avian Kingdom" end
def _aviankingdomin
  _aviankingdom
  # en route are aggro mobs? - ok at H/SH
  run "2u3wn;enter portal;run 3un;open north;run n"
end

# Black Lagoon
#  Doorway Mobs: bullfrog, merman
#  Portal: Black Pendant
def _blacklagoon ; _north ; write "run 34n8w13n16w" ; $area = "Black Lagoon" end
def _blacklagoondown
  _blacklagoon
  invis 1
  run "2n6d;enter crack"
end
def _blacklagoonin
  _blacklagoondown
  run "2n4d"
  invis 0
end

# Cougarian Queendom
# north a bit, and enter the opening (not all the way through to the dead end though)
# roar at the right spot.
def _cougarianqueendom ; _east ; write "run 9e2s6en15e21s6e3n2e5n2e2n; echo run 2n and enter opening" ; $area = "Cougarian Queendom" end
def _cougarian ; _cougarianqueendom end

# Desert Doom
def _desertdoom ; _east ; write "run 9e2s6en15e9e13nunu" ; $area = "Desert Doom" end

# Drageran Empire
# the first two locked doors have keys on the mobs next to them.
# guards are all standard.. they assist.. one has the key.. sigh
# TODO: 'The Head of the Stairs' - north, key=?
# upstairs, east has a portal.. go and then open west, and find the other area.
# portal location
def _drageranempire ; _west ; write "run 2wn2wn4wn8wn14w9s17ws2ws3w2s2w" ; $area = "Drageran Empire" end
def _drageran ; _drageranempire end

# Dread Tower
# Bribe the lazy guards for a key to the door to the north. (15000 gold)
# then enter door n (perm card is key) and say 'i have come to rescue the princess' and you get the key going west
# Doormobs: milo, others?
def _dreadtower ; _west ; write "run 8wn6wsw" ; $area = "Dread Tower" end

# Into the Long Night
def _intothelongnight ; _west ; write "run 2wn2wn4wn8wn14w2w20s15wd" ; $area = "Into the Long Night" end
def _itln ; _intothelongnight end


# The Icy Caldera of Mauldoon
def _theicycalderaofmauldoon ; _north ; write "run 29nw5n16w2n" ; $area = "The Icy Caldera of Mauldoon" end
def _mauldoon ; _theicycalderaofmauldoon end
# The are some stupid aggro mobs en route through the inner rooms..
def _mauldoonin
  _icycalderaofmauldoon
  run "swuwuwd2des"
end
def _mauldoonin2
  _icycalderaofmauldoon
  run "swuwuwd2desdeu"
end

# Mossflower Wood
#Portal: Joseph Bell
def _mossflowerwood ; _east ; write "run 9e2s6en15e6e19s2e" ; $area = "Mossflower Wood" end
def _mossflower ; _mossflowerwood end

# Nottingham
#Doorway Mobs: NONE
# I've never been able to find the entrance to the area while already inside the forest.
# Search for the graffiti, then (with infravision) type "exits" to look for the bridge.
# Kill the mob to get let in.
def _nottingham ; _east ; write "run 9e2s6en15e25s3e" ; $area = "Nottingham" end

# Sanctity of Eternal Damnation
# Portal: A Bloody Griffin Wing (nosave)
# TODO: SW through the portal?
def _sanctityofeternaldamnation ; _north ; write "run 20n9w9nw3ne2ne4n9wn2w2nd" ; $area = "Sanctity of Eternal Damnation" end
def _sanctity ; _sanctityofeternaldamnation end
def _soed ; _sanctityofeternaldamnation end

# The Mountains of Desolation
def _themountainsofdesolation ; _west ; write "run 2wn2wn4wn8wn14w21ws" ; $area = "The Mountains of Desolation" end
def _mod ; _themountainsofdesolation end
# The ghost area which used to be great but got gimped.
def _modghosts ; _themountainsofdesolation ; run "5nen;enter altar" end
# Upstairs to the giants
def _modgiants
  _themountainsofdesolation
  invis 1
  run "2nun2u5w2u2n2unu"
end
# All mobs are aggro, see through invis, are tamable.
# Dwarvish wraith - resist earth, immune fire.
def _modstone
  _themountainsofdesolation
  invis 1
  run "2nun2u5w2un2wuw ; enter stone"
  write "echo To exit this place, go north through the mobs, to the end, then -- enter stone"
end

# The Scarred Lands
# Doormob: "steel" (steel dragon)
# kill dragonsnakes till you get the head, give the head to pete, for the key to the northern door
# kill persistent miner, give pick to wounded miner past the northern door, for key to south door
def _thescarredlands ; _west ; write "run 2wn2wn4wn8wn15ws13w3sw2s3ws4w2n2w3s3wse;enter crack" ; $area = "The Scarred Lands" end
def _scarredlands ; _thescarredlands end

# Soulblade
# TODO: Define what goes where..
def _soulblade ; _west ; write "run 2wn2wn4wn8wn14w9s11w5sw;enter map" ; $area = "Soulblade" end

# Takeda's Warcamp
def _takedaswarcamp ; _east ; write "run 9e2s6en15e9e16n4e2n" ; $area = "Takeda's Warcamp" end
def _takeda ; _takedaswarcamp end

# The Circus (105-135)
# You need to buy a ticket to get in.
# You can walk up the tightrope to go down to the lions.
# def _circus ; _north ; write "run 15n4wn4sesw2s" ; $area = "Circus" end
def _thecircus ; _newofcol ; write "run 4sesw2s" ; $area = "Circus" end
def _circus ; _thecircus end

# Tir na nOg
# Portal: a ring of pale mushrooms 
# TODO: locked door down from the magical tapestry -- the key from who?
def _tirnanog ; _east ; write "run 9e2s6en15e6e26s;sleep" ; $sleep = 0 ; $area = "Tir na nOg" end
def _tir ; _tirnanog end

# Unearthly Bonds
def _unearthlybonds ; _north ; write "run 34n6w14n;op w;w;give 1000 gold receptionist" ; $area = "Unearthly Bonds" end
def _ub ; _unearthlybonds end

# Winterfell
def _winterfell ; _north ; write "run 31n13en" ; $area = "Winterfell" end

# Yggdrasil
#Portal: A Small Crystal Tree 
def _yggdrasil ; _south ; write "run 19s8s14wu" ; $area = "Yggdrasil" end
def _ygg ; _yggdrasil end
def _yggn ; _yggdrasiltheworldtree ; write "n;enter bridge" end
def _yggs ; _yggdrasiltheworldtree ; write "s;enter bridge" end
def _ygge ; _yggdrasiltheworldtree ; write "e;enter bridge" end
def _yggw ; _yggdrasiltheworldtree ; write "w;enter bridge" end
def _yggu ; _yggdrasiltheworldtree ; write "u;enter bridge" end
def _yggd ; _yggdrasiltheworldtree ; write "d;enter bridge" end
