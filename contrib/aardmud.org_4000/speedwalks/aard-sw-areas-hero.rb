# Council of the Wyrm
def _councilofthewyrm ; _east ; write "run 9e2s6en15e11en8e2sdwdw;open w;run 5w2des2en2es2ene2ds2wnws4wn2wd3es2en2es2ene2s5d;echo Kill one of the idiot mobs to sit down." ; $area = "Council of the Wyrm" end
def _wyrm ; _councilofthewyrm end

# Curse of the Midnight Fens
#  201  201  160  Calabus          The Curse of the Midnight Fens
def _curseofthemidnightfens ; _north ; write "run 26n25w" ; $area = "Curse of the Midnight Fens" end
def _fens ; _curseofthemidnightfens end

# Oradrin's Chosen
#  200  201  201  Vilgan           Oradrin's Chosen              
# The level cap is hard-set, and not even remorts are allowed in.
def _oradrinschosen ; recall ; write "run 33s31w10s13we" ; $area = "Oradrin's Chosen" end

# The Cataclysm
#  150  201  120  Baktosh          The Cataclysm
def _cataclysm ; _east ; write "run 9e2s6en15e9e17n" ; $area = "The Cataclysm" end
def _cata ; _cataclysm end
def _catain
  _cataclysm
  vis
  write "sit carriage;stand"
end

# The Were Wood
#  200  201  180  Valkur           The Were Wood                 
def _thewerewood ; _east ; write "run 9e2s6en15e6e25s5e" ; $area = "The Were Wood" end
def _werewood ; _thewerewood end


# Unknown:
#  210  210       Aardwolf         Dark Temple of Zhamet         
#  210  210       Aardwolf         A Clearing in the Woods       
#  201  201  201  Citron           Sea King's Dominion           
#  210  210       Aardwolf         Isle of Anglesey
#  201  201  201  Citron           Sea King's Dominion
#  210  210  200  Aardwolf (Oby &  Secret Imm Project #69        
#  201  201  180  Valkur           The Dungeon of Doom

__END__

#STUPID AREA
#Sea King's Dominion
def _seakingothermethods ; 
Start Location: Temple of Mota  Length: 22          Report Error
run 2s3w;open west;run w5n3e2n3ed2w;echo Wait for the old man to whine about his aching bones and then say seaboon;echo The man leaves as soon as he teleports anyone so be quick

-- beer goblins
Start Location: Temple of Mota  Length: 22    Requires: Passdoor      Report Error
run 2s4w5n3e2n3ed2w;echo Wait for the old man to whine about his aching bones and then say seaboon;echo The man leaves as soon as he teleports anyone so be quick

-- smurf heaven - hefty smurf's home
Start Location: Temple of Mota  Length: 24          Report Error
run 3sw2swu7swse4nws;echo Wait for the old man to whine about his aching bones and then say seaboon; echo The man leaves as soon as he teleports anyone so be quick

-- antharia
Start Location: Temple of Mota  Length: 29    Requires: Boat      Report Error
run 3sw2swd4nes2ed2n3e5nws;echo Wait for the old man to whine about his aching bones and then say seaboon;echo The man leaves as soon as he teleports anyone so be quick

Start Location: Temple of Mota  Length: 35  Level Lock: 120       Report Error
run 3sw2s2w;open east;run eswnws2w3s2ws2wnw2n3w4n;echo Wait for the guard or go north and open the door;echo Then run "4nu, say whfs, run "su, open s, kill elementals if necessary, run "sene;echo Wait for the old man to whine about his aching bones and then say seaboon;echo The man leaves as soon as he teleports anyone so be quick

Start Location: Temple of Mota  Length: 36          Report Error
run 2s3e;open east;run e3n2w3nw2n8w3n2e4nws;echo Wait for the old man to whine about his aching bones and then say seaboon; echo The man leaves as soon as he teleports anyone so be quick

Start Location: Temple of Mota  Length: 37  Level Lock: 30        Report Error
run 2s3w4ne;open s;run s3w2n;open s;run s2wn4w;enter ice;run 13n;echo Wait for the old man to whine about his aching bones and then say seaboon;echo The man leaves as soon as he teleports anyone so be quick

Start Location: AardHotel Length: 38  Level Lock: 120       Report Error
run u2wn4wn2w2nwnws2w3s2ws2wnw2n3w4n;echo Wait for the guard or go north and open the door;echo Then run "4nu, say whfs, run "su, open s, kill elementals if necessary, run "sene;echo Wait for the old man to whine about his aching bones and then say seaboon;echo The man leaves as soon as he teleports anyone so be quick

Start Location: Temple of Mota  Length: 41    Requires: Passdoor      Report Error
run 2s6e3se2s2e2ses2e4se2s3sds2w2send;echo Wait for the old man to whine about his aching bones and then say seaboon;echo The man leaves as soon as he teleports anyone so be quick

Start Location: Temple of Mota  Length: 46    Requires: Boat      Report Error
run 3s2e2s3e2seswse3s2e3sws2esesed2n3e5nws;echo Wait for the old man to whine about his aching bones and then say seaboon;echo The man leaves as soon as he teleports anyone so be quick

Start Location: Temple of Mota  Length: 48          Report Error
run 2s3w;open west;run 4ws2wn2wn3wnw2nwnwn3ws2wnw4undnw2nwsw;echo Wait for the old man to whine about his aching bones and then say seaboon;echo The man leaves as soon as he teleports anyone so be quick

Start Location: Temple of Mota  Length: 48    Requires: Passdoor      Report Error
run 2s7ws2wn2wn3wnw2nwnwn3ws2wnw4undnw2nwsw;echo Wait for the old man to whine about his aching bones and then say seaboon;echo The man leaves as soon as he teleports anyone so be quick

Start Location: Temple of Mota  Length: 52  Level Lock: 120       Report Error
run 2s3w4ne;open s;run s3wnw2n4wn2w2nwnws2w3s2ws2wnw2n3w4n;echo Wait for the guard or go north and open the door;echo Then run "4nu, say whfs, run "su, open s, kill elementals if necessary, run "sene;echo Wait for the old man to whine about his aching bones and then say seaboon;echo The man leaves as soon as he teleports anyone so be quick
" end
