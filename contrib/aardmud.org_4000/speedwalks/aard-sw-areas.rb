# Aarakocran
def _arakocran ; _north ; write "run 15n9ws7w16nu" ; $area = "Aarakocran" end

# Aardwolf Isle Estates
def _aardwolfisleestates ; _south ; write "run 10s31w20s15w" ; $area = "Aardwolf Isle Estates" end

# Aardwolf Real Estates
def _aardwolfrealestates ; _west ; write "run 2wn2wn3w4n" ; $area = "Aardwolf Real Estates" end

# Aardwolf Estates 2000
def _aardwolfestates2000 ; _east ; write "run 9e2s6e2nw5n7e2s2en" ; $area = "Aardwolf Estates 2000" end

# Aardwolf Zoological Park
def _aardwolfzoologicalpark ; _east ; write "run 6en" ; $area = "Aardwolf Zoological Park" end
def _zoo ; _aardwolfzoologicalpark end

# Ancient Greece
#  Doorway Mobs: 'Pericles' (26) 'Thusydides' (28) 'Klisthenes' (30) 'spartan' (34)
def _ancientgreece ; _south ; write "run 24s10w" ; $area = "Ancient Greece" end
def _greece ; _ancientgreece end
def _athens
  _greece
  run "s2wn"
end
def _sparta
  _greece
  run "4se3s"
end
def _thebes
  _greece
  run "se2nen"
end

# Antharia
def _antharia ; _north ; write "run 21n9ed" ; $area = "Antharia" end

# Anthrox
def _anthrox ; _east ; write "run 9e2s6en7e7se7se" ; $area = "Anthrox" end
def _anthroxup
  _anthrox
  run "2ed;open east;run 3e2nu3n;open up;run u"
end

# Arboria
def _arboria  ; _west ; write "run 2wn2wn4wn8wn14w12w8n" ; $area = "Arboria" end

# Astral Travels
# Alizarin: nightmare desert swamp falling torment
# Cerulean: pleasure garden
# Indigo: standing cloud
# Silver: midnight stroke
# Viridian: hidden palace dream trail
def _astraltravels ; _west ; write "run 2wn2wn4wn8wn14w10sw4s3w3su" ; $area = "Astral Travels" end

# Atlantis
def _atlantis ; _south ; write "run 19s4s4e3s" ; $area = "Atlantis" end

# Black Adder
def _blackadder ; _north ; write "run 15n9ws7w16n2wnwnw3ne2n2wn" ; $area = "Black Adder" end
def _blackadder1 ; _blackadder end
def _blackadder_1 ; _blackadder end
def _blackadder2
  run "3nwn;enter cauldron;open east;run e"
end
def _blackadder_2
  _blackadder1
  run "3nwn;enter cauldron;open east;run e"
end
def _blackadder3
  run "e3s2u;enter cannon"
end
def _blackadder_3
  _blackadder2
  run "e3s2u;enter cannon"
end
def _blackadder4
  run "dn2wn;open west;run w;open west;run w;enter prie-dieu"
end
def _blackadder_4
  _blackadder3
  run "dn2wn;open west;run w;open west;run w;enter prie-dieu"
end
def _blackadder5
  run "swnw;enter dread;echo Find the graffiti - open up -- the key is on one of the snails"
end
def _blackadder_5
  _blackadder4
  run "swnw;enter dread;echo Find the graffiti - open up -- the key is on one of the snails"
end

# Blackrose
def _blackrose ; recall ; write "run 33s22ws4w2nw2n;open w;w;vis;buy pass;run e4n3e2nenw;open north;run nd6s2wseu" ; $area = "Blackrose" end

# Casino
# some mobs attack for no real reason
def _casino ; recall ; write "run 6s3ws8e" ; $area = "Casino" end

# Castle Reinhold
def _castlereinhold ; recall ; write "run 33s2ws4wn5wnwn" ; $area = "Castle Reinhold" end
def _reinhold ; _castlereinhold end

# Castle Vlad-Shamir
#  Doorway Mobs: 'mortal slave' (54) 'demon berserker' (62) 'draco' (62) 'DFC' (80) 'Demon Navy' (82) 'DDC' (82) 
# a guard has the key:  misty potion
def _castlevladshamir ; _east ; write "run 9e2s6en15e6e16s10e" ; $area = "Castle Vlad-Shamir" end
def _vladshamir ; _castlevladshamir end

# Chessboard
def _chessboard ; recall ; write "run 2s5es;watch game" ; $area = "Chessboard" end

# Christmas Vacation
def _christmasvacation ; _north ; write "38n" ; $area = "Christmas Vacation" end
def _xmasvacation ; _christmasvacation end
def _xmas ; _christmasvacation end

# Coral Kingdom
def _coralkingdom ; _south ; write "run 19s22w3sd" ; $area = "Coral Kingdom" end

# Courts of Chaos
def _courtsofchaos ; _west ; write "run 2wn2wn4wn8wn14w15w3n5w2n4w" ; $area = "Courts of Chaos" end
def _coc ; _courtsofchaos end

# Coven
# shovel from armorer (west) is for west door
# through the west door, kill the snake for the key to the east door
def _coven ; _east ; write "run 17e6s" ; $area = "Coven" end

# Covenant of Mistridge
# have to be let in by the gateguard:: A Gregarious Gateguard says 'You may now enter,  <name>.'
# key is on each of the two guard mobs.
def _covenantofmistridge ; _east ; write "run 9e2s6en15e9e16n8e6n;open n" ; $area = "Covenant of Mistridge" end
def _mistridge ; _covenantofmistridge end
def _mistridgewhfs
  _mistridge
  run "5nu"
  vis
  write "say whfs"
end

# Cradlebrook
def _cradlebrook ; _east ; write "run 9es15es" ; $area = "Cradlebrook" end

# Crystalmir Lake
def _crystalmirlake ; _west ; write "run 2wn2wn9w3nw" ; $area = "Crystalmir Lake" end
def _crystalmir ; _crystalmirlake end

# Cthos Mishrak
def _cthosmishrak ; _east ; write "run 9e2s6en15e8e3n9e" ; $area = "Cthos Mishrak" end
def _cthos ; _cthosmishrak end
def _cthosdown
  _cthosmishrak
  write "give 2000 gold kalvor;run nede;get robes;wear robes;get amulet;wear amulet;run w3n2e"
end
def _cthosin
  _cthosdown
  write "remove robes;drop robes;remove amulet;drop amulet"
  # NOTE: This is an assumption.
  write "wear breastplate;wear cloak"
end

# Dangerous Neighborhood
def _dangerousneighborhood ; recall ; write "run 6s3ws" ; $area = "Dangerous Neighborhood" end
def _dangerousneighbourhood ; _dangerousneighborhood end

# Dark Elf Stronghold
# The gateguard is aggro and sees invis.
def _darkelfstronghold ; _north ; write "run 28n8e12neu" ; $area = "Dark Elf Stronghold" end
def _darkelf ; _darkelfstronghold end
def _darkelfswirling
  _darkelfstronghold
  write "run 2nenwn;open up;run use;enter swirling"
end
def _darkelfpainting
  _darkelfswirling
  write "run 3e;open east;run e;enter painting"
end

# Dark Temple of Zyian
# First locked door - 
def _darktempleofzyian ; _west ; write "run 2wn2wn4wn8wn14w9s11w4s3ws3w2n" ; $area = "Dark Temple of Zyian" end
def _zyian ; _darktempleofzyian end
def _zyan ; _darktempleofzyian end

# Deadlights
# Portal: Timeless Seal of the Ages
# TODO: Integrate exit SWs.
def _deadlights ; _west ; write "run 2wn2wn4wn8wn14w21ws2nun2ununwn4u" ; $area = "Deadlights" end

# Death's Manor
def _deathsmanor ; recall ; write "run 29s10w" ; $area = "Death's Manor" end

# Death Gate
def _deathgate ; recall ; write "run 33s19w4n" "echo find Lost Adventurer, then -- run 2n3e2nu3w4s4e4nu4w2sw2ue2s4e4nu2w2s5w2n" ; $area = "Death Gate" end
# say 'yes'

# Deathtrap Dungeon
def _deathtrapdungeon ; _north ; write "run 13n7en9e4n2e4d;op w;run 17w3sw5s2w;op w;run 3w2n" ; invis 1 ; $area = "Deathtrap Dungeon" end
def _deathtrap ; _deathtrapdungeon end

# Den of Thieves
def _denofthieves ; recall ; write "run 33s21ws" ; $area = "Den of Thieves" end
def _denoftheives ; _denofthieves end

# Descent to Hell
# TODO: More SWs
def _descenttohell ; _east ; write "run 9e2s6en15e11en8e2sd" ; $area = "Descent to Hell" end
def _hell ; _descenttohell end
def _descenttohellin
  _descenttohell
  run "4w2des2en2es2ene2ds2wnws4wn2wd3es;open east;run 2en;open east;run 2es2en;open east;run e2s"
end

# Desert Prison
def _desertprison ; _east ; write "run 9e2s6en15e7e6ne" ; $area = "Desert Prison" end

# Diamond Soul Revelation
def _diamondsoulrevelation ; recall ; write "run 33s25wds;open south" ; $area = "Diamond Soul Revelation" end
def _dsr ; _diamondsoulrevelation end
def _dsr ; _diamondsoulrevelation end
def _dsrin
  _dsr
  run "3sd2wd"
end
def _dsryaks
  _dsrin
  run "2e;open e;run e;open n;run n"
end

# Dortmund
def _dortmund ; _east ; write "run 19e" ; $area = "Dortmund" end

# Dragon Cult
# receptionist at the entrance has the black key for the entrance
def _dragoncult ; recall ; write "run 33s17wn ; open north; echo The receptionist has the key." ; $area = "Dragon Cult" end

# Dragon Mountain
# TODO: Is this still locked by the punk gategard, and accessed through another area?
def _dragonmountain ; _west ; write "run 2wn2wn4wn8wn14w9s15w2s;op u;u" ; $area = "Dragon Mountain" end

# Dungeon of Doom
def _dungeonofdoom ; _east ; write "run 9e2s6en15e13s10ed" ; $area = "Dungeon of Doom" end

# Dwarven Catacombs
def _dwarvencatacombs ; recall ; write "run 33s22ws4w2nw2n;open w;w;vis;buy pass;run e4n3e2nenw;op n;run nd" ; $area = "Dwarven Catacombs" end

# Earth Plane 4
def _earthplane4 ; _north ; write "run 13n29e26n" ; $area = "Earth Plane 4" end

# Entrance to Hades
def _entrancetohades ; _west ; write "run 2wn2wn4wn8wn14w8w6s" ; $area = "Entrance to Hades" end
def _hades ; _entrancetohades end
def _hadesin
  _entrancetohades;run n
  write "sit altar;worship hermes"
end

# Faerie Tales II
def _faerietalesii ; recall ; write "run 33s13w3sw3sesw5sus2w2s3e" ; $area = "Faerie Tales II" end
def _ft2 ; _faerietalesii end
def _ft2star
  _ft2
  run "e3s10e7nese;write fstar"
end

# Faerie Tales
def _faerietales ; recall ; write "run 33s13w3sw3sesw5su" ; $area = "Faerie Tales" end
def _ft ; _faerietales end

# Falcovnia
# it's a good idea to sneak / pass without trace.  Invis alone won't let you run past the fucking rats / gateguard
# fucking gateguard attacks based on align. -- so do other mobs
# norecall in at least some areas (road to lekhar)
# entrance gate isn't locked
def _falcovnia ; _east ; write "run 9e2s6en2es6e5s3eu2nenen4eseu" ; $area = "Falcovnia" end
def _falcovniagate
  _falcovnia
  pprint "Good luck getting past the rats and gateguard."
  write "run n9en;open north"
end
def _falcovniacastle
  _falcovniagate
  write "run 11n;open north"
end

# Fantasy Fields
def _fantasyfields ; _north ; write "run 3n6e;sleep" ; $area = "Fantasy Fields" end

# Foolish Promises
def _foolishpromises ; _north ; write "run 34n8w7n20wu" ; $area = "Foolish Promises" end
def _lidnesh ; _theforestoflidnesh end

# Fort Terramire
def _fortterramire ; _north ; write "run 13n7en9e4n2eu" ; $area = "Fort Terramire" end
def _terramire ; _fortterramire end
def _teramire ; _fortterramire end

# Giant's Pet Store
def _giantspetstore ; _east ; write "run 6ene3n;open w;w;open w;run wsws" ; $area = "Giant's Pet Store" end

# Gilda and the Dragon
def _gildaandthedragon ; recall ; write "run 27s5w" ; $area = "Gilda and the Dragon" end
def _gilda ; _gildaandthedragon end
def _gildain
  _gildaandthedragon
  # Cave with Sir Lauren.
  run "4n;open n;run nwnwn2e2swnwdsdndsd"
end

# Gold Rush
def _goldrush ; _west ; write "run 2wn2w2n" ; $area = "Gold Rush" end
def _goldrushinside
  invis 1
  _goldrush
  run "4n4w;enter mining car"
  invis 0
end

# Halls of the Damned
# kill eight armed skeleton (wimpy, moves) for the belt
# give it to the wounded warrior for cat eye
# give eye to exorcising for cross
# give cross to Darkon Stills at start for star key
def _hallsofthedamned ; _west ; write "run 2wn2wn4wn8wn14w27wne" ; $area = "Halls of the Damned" end

# Island of Lost Time
def _islandoflosttime ; recall ; write "run 33s22w2n9wn" ; $area = "Island of Lost Time" end

# Jenny's Tavern
# see also yurgachdomain and adventurerswayhouse
# Kali's avatar has a portal (pendant) to yurgach domain
# from yurgach, go south and west a bit.. find the sentry.  kill for the key. Then east and down.. in the prison area.  No key needed down there.
def _jennystavern ; _north ; write "run 13n7en10enes2e2n7en;open u;u" ; $area = "Jenny's Tavern" end

# Jungles of Verume
def _junglesofverume ; _east ; write "run 9e2s6en15e21s2e" ; $area = "Jungles of Verume" end
def _verume ; _junglesofverume end

# Kerofk
# TODO: There is another entrance, I think.
def _kerofk ; _north ; write "run 13n7en10e" ; $area = "Kerofk" end

# Kingdom of Ahner
def _kingdomofahner ; recall ; write "run 28s7w" ; $area = "Kingdom of Ahner" end
def _ahner ; _kingdomofahner end

# Kul Tiras
def _kultiras ; _west ; write "run 2wn2wn4wn8wn14w9s11w4s3ws4w2s3w" ; $area = "Kul Tiras" end

# Magical Hodgepodge
def _magicalhodgepodge ; _north ; write "run 4ne4n2ese2w4n" ; $area = "Magical Hodgepodge" end

# Market Road
def _marketroad ; recall ; write "run 33s2es4e" ; $area = "Market Road" end

# Mount Olympus
# Portal: Amulet of the Planes (pool 9)
def _mountolympus ; _east ; write "run 18e3n" ; $area = "Mount Olympus" end

# Myst
#Portal: a White Page (lvl 1)
def _myst ; _west ; write "run 2wn2wn4wn8wn15ws13w3sw2s3ws4w2n2w7s4w" ; $area = "Myst" end

# Nanjiki Ruins
#Portal: A Magic Banana
def _nanjikiruins ; _east ; write "run 9e2s6en2es6en7e6e21s6es4eses" ; $area = "Nanjiki Ruins" end
def _nanjiki ; _nanjikiruins end

# Necromancer's Guild
def _necromancersguild ; _east ; write "run 9e2s8es2e5ses;open s;run 3s" ; $area = "Necromancer's Guild" end

# New Ofcol
def _newofcol ; _north ; write "run 15n4wn" ; $area = "New Ofcol" end

# New Thalos
def _newthalos ; recall ; write "run 33s2wsw5s" ; $area = "New Thalos" end

# Northstar
def _northstar ; _north ; write "run 15n4w6nu;open n;n;ent iloveivar;open w;w" ; $area = "Northstar" end

# Old Thalos
def _oldthalos ; recall ; write "run 33s2wsw5sw" ; $area = "Old Thalos" end

# Olde World Carnivale
def _oldeworldcarnivale ; recall ; write "run 24se" ; $area = "Olde World Carnivale" end
def _carnivale ; _oldeworldcarnivale end
def _carnival ; _oldeworldcarnivale end

# Paradise Lost
def _paradiselost ; _north ; write "run 29n4ed" ; $area = "Paradise Lost" end

# A Peaceful Giant Village
def _apeacefulgiantvillage ; _west ; write "run 2wn2wn4wn8wn14w21ws4n" ; $area = "A Peaceful Giant Village" end
def _pgv ; _apeacefulgiantvillage end

# Pompeii
# TODO: Verify: scroll is the key to north.  the mob in the north room has an 'invite' (rots) that is key to palaestra
def _pompeii ; _south ; write "run 19s5s2e" ; $area = "Pompeii" end

# Raganatittu
def _raganatittu ; _east ; write "run 9e2s6en15e4e18s" ; $area = "Raganatittu" end
def _raga ; _raganatittu end

# Ranger Heaven (was: Smurf Heaven)
# In really bad taste..
def _rangerheaven ; recall ; invis 1 ; write "run 2s17e2s6en15e4e7su" ; $area = "Ranger Heaven" end

# Rokugan, the Shadowlands
# naga warlord is near the entrance
def _rokugantheshadowlands ; _east ; write "run 9e2s6en15e6e8s6e" ; $area = "Rokugan, the Shadowlands" end
def _rokugan ; _rokugantheshadowlands end

# Seven Wonders
def _sevenwonders ; _south ; write "run 19s5s10w6swn" ; $area = "Seven Wonders" end
def _bermuda
  _sevenwonders
  run "2e2ne;enter lighthouse;open south;s;enter bermuda"
end

# Shadar Logoth
# [70]
# lv 192 Portal: "crown of swords" is mostly _shadarin
def _shadarlogoth ; _north ; write "run 17n16wswsws2w3s2eu" ; $area = "Shadar Logoth" end
def _shadarlogothrats
  _shadarlogoth
  run "4ne3s3e2n2esesd2w;open down;run d"
end
def _shadarin
  _shadarlogoth
  run "6ne2n;open north;run 3n"
  vis
  # NOTE: 50k
  write "buy mashadar"
  run "2s2wd2n;run w;open north;run ne;open north;run nwn2uswdn;enter device"
  vis
  write "drop mashadar;run n"
end

# Shayol Ghul
# the dirty key can be stolen, so it lasts longer
# Portal: Valere
def _shayolghul ; _west ; write "run 2wn2wn4wn8wn14w9s11w4s3w4sw2u2n;open d" ; $area = "Shayol Ghul" end
def _shayolin
  _shayolghul
  run "3dse2swnw;open d;run d3e2sw;open d;run d2nw2d"
end
def _shayolp ; portal "valere" end

# Silver Volcano
def _silvervolcano ; _west ; write "run 2wn2wn4wn8wn14w18w2s" ; $area = "Silver Volcano" end

# Slaughterhouse
def _slaughterhouse ; _west ; write "run 2wn2wn4wn8wn14w15w3n5w6n" ; $area = "Slaughterhouse" end

# Snuckles Village
def _snucklesvillage ; recall ; write "run 32s13e" ; $area = "Snuckles Village" end

# Solace
def _solace ; _west ; write "run 2wn2wn5w" ; $area = "Solace" end

# Stonekeep
def _stonekeep ; _west ; write "run 2wn2wn4wn8wn14w4s24w;jump shaft" ; $area = "Stonekeep" end

# Storm Mountain
def _stormmountain ; _north ; write "run 28n9e8n" ; $area = "Storm Mountain" end

# Tai'rha Laym
def _tairhalayme ; _west ; write "run 2wn2wn4wn8wn14w13w3s" ; $area = "Tai'rha Laym" end
def _taralame ; _tairhalayme end

#
# The
#

# The Adventurers Wayhouse
def _theadventurerswayhouse ; _west ; write "run 2wn2wn4wn8wn14w15w3n3ws" ; $area = "The Adventurers Wayhouse" end
def _wayhouse ; _theadventurerswayhouse end

# The Amazon Nation
# 120-201 [100]
def _theamazonnation ; _east ; write "run 9e2s6en2es6en7e6e21s5e" ; $area = "The Amazon Nation" end
def _amazonnation ; _theamazonnation end
def _amazon ; _theamazonnation end
def _amazoncastle
  _amazonnation
  run "es3e;open north;run 8n;open north"
end
def _amazonyaks
  _amazoncastle
  run "2n2ese;open east;run e"
end

# The City of Amador
def _thecityofamador ; _west ; write "run 2wn2wn4wn8wn14w9s13wn" ; $area = "The City of Amador" end
def _amador ; _thecityofamador end
def _amadorin
  _amador
  run "10n2eue2se;open north;run n;enter sunburst"
end
def _amadordome
  invis 1
  _amador
  write "run 9n5e"
end

# The Dragon Tower
def _thedragontower ; _west ; write "run 2wn2wn4wn8wn3w7s;open north;echo The dragon has the key." ; $area = "The Dragon Tower" end
def _dragontower ; _thedragontower end

# The Dwarven Kingdom
def _thedwarvenkingdom
  recall
  write "run 33s22ws4w"
  write "get 'paper general passport' #{$bag} ; run n ; put 'paper general passport' #{$bag}"
  $area = "The Dwarven Kingdom"
end

# The Eighteenth Dynasty
def _theeighteenthdynasty ; _north ; write "run 13n7en4en3n;open d;run 4dws" ; $area = "The Eighteenth Dynasty" end
def _18thdynasty ; _theeighteenthdynasty end
def _18th ; _theeighteenthdynasty end

# The Elemental Canyon
# I wouldn't call this a newbie area, since it has a tough set of mobs in some places, and some assisters.
def _theelementalcanyon ; _north ; write "run 13n7en5e3neu" ; $area = "The Elemental Canyon" end
def _elementalcanyon ; _theelementalcanyon end
def _elemental ; _theelementalcanyon end

# The Empire of Talsa
def _theempireoftalsa ; _north ; write "run 34n3e12n;enter ladder" ; $area = "The Empire of Talsa" end
def _talsa ; _theempireoftalsa end
# evil-aligned mob area
def _moricand
  _talsa
  run "2us;say moricand"
end
# good-aligned mob area
# The palace: _conadrain, kill farmer for clothes, wear conadrain clothes, give vegetable sarah.
def _conadrain
  _talsa
  run "2us;say conadrain"
end

# The Empire of the Tsuranuanni
def _theempireofthetsuranuanni ; recall ; write "run 33s31w10s23w14s31wsu" ; $area = "The Empire of the Tsuranuanni" end
# who in the hell can spell that?
def _tsur ; _theempireofthetsuranuanni end

# The Realm of Evil Heroes
def _therealmofevilheroes ; _east ; write "run 18en14e2s3e;open d;run dw3n3e4s3w" ; $area = "The Realm of Evil Heroes" end
def _evilheroes ; _therealmofevilheroes  end
def _evilheros ; _therealmofevilheroes  end

# The Fabled City of Stone
def _thefabledcityofstone ; _east ; write "run 9e2s6en18e5sws2w2ses2e4swsw5s4e4sd" ; $area = "The Fabled City of Stone" end
def _fabledcity ; _thefabledcityofstone end
def _cityofstone ; _thefabledcityofstone end
def _fabledcityofstonein
  _thefabledcityofstone
  # locked door gateguard..
  write "open down;run dnse;enter bush;run ew2n;enter opening;run en;open north;run 5n;open north;run n"
end

# The Flying Citadel
def _theflyingcitadel
  recall
  write "run 2s17e2s6en15e5end;echo say join the light;echo say join the dark"
  $area = "The Flying Citadel"
end
def _citadel ; _theflyingcitadel end

# The Gauntlet
def _thegauntlet ; _north ; write "run 13n7en4en" ; $area = "The Gauntlet" end
def _gauntlet ; _thegauntlet end

# The Goblin Fortress
def _thegoblinfortress ; _west ; write "run 2wn2wn4wn8wn21w11sd" ; $area = "The Goblin Fortress" end
def _goblinfortress ; _thegoblinfortress end

# The Graveyard
def _thegraveyard ; _east ; write "run 9e2s7e" ; $area = "The Graveyard" end
def _graveyard ; _thegraveyard end

# The Great City of Knossos
#  Doorway Mobs: senator
#  Portal: Passport to Knossos
def _thegreatcityofknossos ; _south ; write "run 19s5s10w6se3nenwnd" ; $area = "The Great City of Knossos" end
def _knossos ; _thegreatcityofknossos end
def _knossosin
  _knossos
  write "run nes;buy steak;run n2ws2n;buy silver;run 2swn;enter shack;give steak hobo;run esen2en2w;enter crack;give silver sayra"
  # Some aggro mobs detect invisibility.
  write "trace"
  write "run 2e4nwn"
  vis
  write "give identification guard;give passport guard"
end

# The Great Salt Flats
def _thegreatsaltflats ; _east ; write "run 9e2s6en15e9e13nu" ; $area = "The Great Salt Flats" end
def _greatsaltflats ; _thegreatsaltflats end

# The High Tower of Sorcery
def _thehightowerofsorcery ; recall ; write "run 33s19w4n" ; $area = "The High Tower of Sorcery" end
def _hightower ; _thehightowerofsorcery end

# The Highlands
def _thehighlands ; _north ; write "run 15n9ws7w3n" ; $area = "The Highlands" end
def _highlands ; _thehighlands end

# The Imperial City of Reme
def _theimperialcityofreme ; _east ; write "run 18en8e" ; $area = "The Imperial City of Reme" end
def _reme ; _theimperialcityofreme end

# The Island of Stardock
def _theislandofstardock ; _south ; write "run 19s12s11en" ; $area = "The Island of Stardock" end
def _stardock ; _theislandofstardock end

# The Isle of Quake
# TODO: figure out a SW to get to the beach past the maze
#       possibly make speedwalks which go further inside.
def _theisleofquake ; _north ; write "run 13n28e5n" ; $area = "The Isle of Quake" end
def _quake ; _theisleofquake end

# The Keep of Mahn-Tor
def _thekeepofmahntor ; _east ; write "run 9e2s6en2es6e5s3e" ; $area = "The Keep of Mahn-Tor" end
def _mahntor ; _thekeepofmahntor end

# The Killing Fields
#  Doorway Mobs: 'zombie nomad', 'vaida'
#  Portal: a trip to the killing fields
def _thekillingfields ; _east ; write "run 9e2s6en15e12e" ; $area = "The Killing Fields" end
def _killingfields ; _thekillingfields end

# The Labyrinth
def _thelabyrinth ; _north ; write "run 11n14e" ; $area = "The Labyrinth" end
def _labyrinth ; _thelabyrinth end

# The Land of Dominia
# FIXME: I don't know if the invisibility is necessary these days.. since continents are in.
def _thelandofdominia ; _north ; invis 1 ; write "run 6n8es2n" ; invis 0 ; $area = "The Land of Dominia" end
def _dominia ; _thelandofdominia end
def _darksideofdominia
  _dominia
  write "enter jet;run n"
end

# The Land of Oz
def _thelandofoz ; recall ; write "run 33s22w3n4w" ; $area = "The Land of Oz" end
def _oz ; _thelandofoz end
def _ozup
  _oz
  # to the yellow brick road:
  run "4ne2unwu2n2e2u"
end
def _ozupin
  _ozup
  # just past the witch, to the castle:
  run "4nene2nw4n3en2e5n;open north;run n"
end

# The Marshlands of Agroth
def _themarshlandsofagroth ; _east ; write "run 9e2s6es6e9se" ; $area = "The Marshlands of Agroth" end
def _agroth ; _themarshlandsofagroth end

# The Mirror Realm
def _themirrorrealm ; _north ; write "run 6n8es2ne" ; $area = "The Mirror Realm" end
def _mirrorrealm ; _themirrorrealm end
def _mirror ; _themirrorrealm end

# The Misty Shores of Yarr
def _themistyshoresofyarr ; _south ; write "run 19s4s18e" ; $area = "The Misty Shores of Yarr" end
def _yarr ; _themistyshoresofyarr end

# The Monastary
# kill the hidden sentry to the east for the key (passdoorable)
def _themonastery ; _east ; write "run 19e8wne" ; $area = "The Monastary" end
def _monasteryinside
  _monastery
  run "se2sw;open south;run s;close north;lock north"
  # blue key is on a martial master (evil), east from here
end

# The Nine Hells
# $area = "The Nine Hells"
def _theninehells ; _unknown end
def _ninehells ; _theninehells end

# The Old Cathedral
def _theoldcathedral ; _east ; write "run 19e10w" ; $area = "The Old Cathedral" end
def _oldcathedral ; _theoldcathedral end
def _oldcathedralin
  _oldcathedral
  run "n;open north;run 4n;open west;run wd;open south"
end

# The Onslaught of Chaos
# Pyaray - up in the ship, has the ring
def _theonslaughtofchaos ; _east ; write "run 9e2s6en2es6e7se5se3s3en2ws" ; $area = "The Onslaught of Chaos" end
def _onslaught ; _theonslaughtofchaos end
def _onslaughtin
  write "run e;enter hope"
end

# The Pirate Ship
def _thepirateship ; _north ; write "run 15n9w4n" ; $area = "The Pirate Ship" end
def _pirateship ; _thepirateship end
def _pirateshipin
  _pirateship
  run "4neu"
end

# The Port
def _theport ; _east ; write "run 9e2s6en2es6e7se5se3s2e" ; $area = "The Port" end
def _port ; _theport end

# The Prison
# the gatekeeper has the key
def _theprison ; _west ; write "run 2wn2wn4wn8wn14w11sw7s11ws14w2n;open north" ; $area = "The Prison" end
def _prison ; _theprison end

# The Reman Conspiracy
def _theremanconspiracy ; _east ; write "run 18en14e2s3e;open d;run dw" ; $area = "The Reman Conspiracy" end
def _reman ; _theremanconspiracy end
# TODO: Add other SWs:
# run "6en2en2e2s6e2s3e;open down;run dw"
# run "6en2en2e2s6e2s5e3s;give 1000 gold armsmaster"

# The River of Despair
def _theriverofdespair ; _east ; write "run 9e5se" ; $area = "The River of Despair" end
def _riverofdespair ; _theriverofdespair end

# The Ruins of Diamond Reach
def _theruinsofdiamondreach ; _north ; write "run 27n6w" ; $area = "The Ruins of Diamond Reach" end
def _ruinsofdiamondreach ; _theruinsofdiamondreach end
def _diamondreach ; _theruinsofdiamondreach end

# The School of Horror (120-175, 125-201)
# The guard at entrance has the key
def _theschoolofhorror ; _west ; write "run 2wn2wn4wn8wn14w15w3n5w5n3e5n" ; $area = "The School of Horror" end
def _schoolofhorror ; _theschoolofhorror end
def _soh ; _theschoolofhorror end

# The Temple of Shal'indrael
# to get to barrack:: door 'essence fire';s
# Barrack's Yin-Yang Chakram -- savable key, can then SW in.
# The run to Barrack is: from start with chakram in hand: run 2s;open south;open south;s;enter portal;run sd;enter silver;run ewe2s
# with barrack's pendant, the Test of Darkness is:: enter;run 2sd;enter silver;run ewe
def _thetempleofshalindrael ; _west ; write "run 2wn8ws" ; $area = "The Temple of Shal'indrael" end
def _templeofshalindrael ; _thetempleofshalindrael end
def _shalindrael ; _thetempleofshalindrael end
def _shalindrel ; _thetempleofshalindrael end
def _shal ; _thetempleofshalindrael end
# def _shalp ; 

# The Temple of Shouggoth
def _thetempleofshouggoth ; _east ; write "run 9e2s6en15e6e6s10e;echo scan for camel, its west from it" ; $area = "The Temple of Shouggoth" end
def _templeofshouggoth ; _thetempleofshouggoth end
def _shouggoth ; _thetempleofshouggoth end

# The Temple of the White Lotus
# Has supernewbie quests.
def _thetempleofthewhitelotus ; _north ; write "run 13n7en8e2n;open south;run 5s;open south" ; $area = "The Temple of the White Lotus" end
def _templeofthewhitelotus ; _thetempleofthewhitelotus end
def _totwl ; _thetempleofthewhitelotus end

# The Three Pillars of Diatz
def _thethreepillarsofdiatz
  recall
  write "run 2s10wn2wn4wn8wn5we8nwu;echo say stone, glass or marble"
  $area = "The Three Pillars of Diatz"
end
def _threepillarsofdiatz ; _thethreepillarsofdiatz end
def _diatz ; _thethreepillarsofdiatz end

# The Tournament of Illoria
def _thetournamentofilloria ; _west ; write "run 2wn2wn4wn8wn14w15w3n5w5n3e4n9es" ; $area = "The Tournament of Illoria" end
def _tournamentofilloria ; _thetournamentofilloria end
def _illoria ; _thetournamentofilloria end

# The Tree of Life
def _thetreeoflife ; _west ; write "run 6w8nu" ; $area = "The Tree of Life" end
def _treeoflife ; _thetreeoflife end
def _tol ; _thetreeoflife end

# The Underdark
def _theunderdark ; _north ; write "run 13n7en9e4n2e" ; $area = "The Underdark" end
def _underdark ; _theunderdark end

# The Valley of the Elves
def _thevalleyoftheelves ; recall ; write "run 33s13w3s" ; $area = "The Valley of the Elves" end
def _valleyoftheelves ; _thevalleyoftheelves end

# The Wood Elves of Nalondir
def _thewoodelvesofnalondir ; _east ; write "run 18e3s3e" ; $area = "The Wood Elves of Nalondir" end
def _nalondir ; _thewoodelvesofnalondir end

# The Yurgach Domain
# see also Jenny's Tavern
# Kali's avatar in jennystavern has a portal (pendant) to yurgach domain
# weeds are aggo
def _theyurgachdomain ; recall ; invis 1 ; write "run 2s10wn2wn4wn8wn14w11sw7s11ws14wse" ; $area = "The Yurgach Domain" end
def _yurgach ; _theyurgachdomain end
def _yurgachgates
  _yurgachdomain
  run "4sw5s3e2s2e3s2e3se;open south"
end
def _yurgachin
  _yurgachdomain
  run "4sw5s3e2s2e3s2e3se;open south;run s4e2de2s2wd2n2u;open north;run n"
end

#
#
#

# Verdure Estate
def _verdureestate ; recall ; write "run 33s2wsw5sw2s4w3s2wnen" ; $area = "Verdure Estate" end
def _verdure ; _verdureestate end
def _verdue ; _verdureestate end
def _verdurein
  _verdureestate
  write "run w;open w;run 4we2n;drop 'verdure token'"
end

# War of the Wizards
def _warofthewizards ; _west ; write "run 3w2s" ; $area = "War of the Wizards" end

# Wedded Bliss
def _weddedbliss ; recall ; write "run 33s6wn" ; $area = "Wedded Bliss" end


# The Lower Planes
# 70-100 [50]
# first pool -- go south as far as possible, 2en and give 3000 coins mallic'
def _thelowerplanes ; _unknown ; write "echo use an amulet of the planes (min. level 25)" ; $area = "The Lower Planes" end
def _lowerplanes ; _thelowerplanes end


# The Gladiator's Arena
# 80-100, Atreidess
def _thegladiatorsarena
  pprint "u27enu from hotel"
  $area = "The Gladiator's Arena"
end
def _gladiator ; _thegladiatorsarena end

# Siren's Oasis Resort
# 5-15, Nikkei & Nasdaq
def _sirensoasisresort ; _west ; write "2wn2wne5n" ; $area = "Siren's Oasis Resort" end
def _siren ; _sirensoasisresort end
