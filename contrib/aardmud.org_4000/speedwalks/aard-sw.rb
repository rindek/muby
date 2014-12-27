# Getting to the gates in Aylor:
# The Blessed Aylorian Highway
# def _north ; _aylor ; write "run 4ne;open north;run 2nw4n" end
def _north ; _aylor ; write "run 2s8enw" end
# Eastern High Road
def _east ; _aylor ; write "run 2s8e" end
# Western High Road
def _west ; _aylor ; write "run 2s8w" end
# Great Andolor Highway
# def _south ; _aylor ; write "run 23s" end
def _south ; _aylor ; write "run 2s8esw" end


def _id ; _aylor ; write "run 2s4e2n" end

def _unknown
  write "echo this speedwalk is not yet known"
end



#
# Continents
#
# While running on the continents, running on roads will generally be faster than running over other land, unless of course you are flying then it makes no difference.
# Some areas have multiple entrances from the same continent room depending on which direction you enter them.

# Gelidus
def _gelidus ; write "run 4ne;op n;run 2nw3n21n" end
# Alagh
def _alagh ; write "run 2s17e2s6en15e" end
# Abend
def _abend ; write "run 2s10wn2wn4wn8wn14w" end
# Southern Ocean
def _southernocean ; write "run 22s" end
# Uncharted Ocean
def _unchartedocean ; write "run 33s31w10s" end



# Near to Aylor:
def _angorbridge
  _west
  run "2wn2wn4wn8wn2w"
end
