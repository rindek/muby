#
# Helpers for items:
#   bid, rbid, lore, identify and appraise.
#


# FIXME: When I rbid on something, it outputs the last known variables.  It's probably the alias doing it..
# weight check is getting weird numbers..

# TODO: Re-report the cost for the item.  Compare the numbers and report the amount of QPs lost/won so far.
# Save the item into a hash with @item_number as its key, and the value as [@base, @tps]
# Remort Auction: Bid of (\d+) Qp on .* (Level \d+, Num (\d+)) going (once|twice)\.
# Remort Auction: .* (Level \d+, Num (\d+)) sold to \w+ for (\d+) Qp\.

# /receive "Remort Auction: SySy is selling a level 200 Aardwolf Aura of Sanctuary (Num 3).\n"
# Remort Auction: Starting bid is 100 Qp\. \(See 'help rbid'\)
# FIXME: This is busted!
conf.remote_triggers[/^DISABLED   Remort Auction: \w+ is selling a level (\w+) (.*) \(Num (\d+)\)\.$/] = Proc.new do |inwin, outwin, match|
# FIXME: Bug with this not setting rbid off properly:
# weight has changed: 10 => 
# NoMethodError: undefined method `<' for nil:NilClass

#   @level = match[1]
  @item = match[2]
  @item_number = match[3]
  wasafk = 0
  if $afk == 1 then wasafk == 1 ; afk 0 end
  # Catch all the information:
  id
  # Hijack the next prompt (overwrites what 'id' does)
  conf.remote_triggers[$prompt] = Proc.new do
    rbid_tp_checker
    pprint "A base of #{@base} + #{@tps} TPs = #{@base+(@tps*75)}"
    id_teardown
  end
  # Trigger off the above:
#   write "rbid #{@item_number}"
  # Return me to my afk-ness:
  if wasafk == 1 then afk 1 end
end

# TODO: Item flag changes..
# TODO: keepflag = 6TPs
# Catch the difference in hr/dr.  Check the level, know the expected hr/dr.  When higher, add 1TP cost per point difference.
# TODO: Work with my level, tiers and the keepflag wish.  Note things that are out of my range.
def rbid_tp_checker
  @tps = 0
  case @item
    when "Axe of Aardwolf"                          ; @base = 1000 ; original_weight = 20 ; original_type = "axe"     ; base_damtype = "cleave"        ; base_flag = "vorpal"
    when "Dagger of Aardwolf"                       ; @base = 1000 ; original_weight = 10 ; original_type = "dagger"  ; base_damtype = "pierce"        ; base_flag = "sharp"
    when "Flail of Aardwolf"                        ; @base = 1000 ; original_weight = 25 ; original_type = "flail"   ; base_damtype = "beating"       ; base_flag = "vampiric"
    when "Halberd of Aardwolf"                      ; @base = 1000 ; original_weight = 25 ; original_type = "polearm" ; base_damtype = "drain"         ; base_flag = "changing"
    when "Mace of Aardwolf"                         ; @base = 1000 ; original_weight = 20 ; original_type = "mace"    ; base_damtype = "pound"         ; base_flag = "frost"
    when "Staff of Aardwolf"                        ; @base = 1000 ; original_weight = 15 ; original_type = "spear"   ; base_damtype = "thwack"        ; base_flag = "shocking"
    when "Sword of Aardwolf"                        ; @base = 1000 ; original_weight = 35 ; original_type = "sword"   ; base_damtype = "slice"         ; base_flag = "flaming"
    when "Whip of Aardwolf"                         ; @base = 1000 ; original_weight = 15 ; original_type = "whip"    ; base_damtype = "shocking bite" ; base_flag = "vampiric"
    when "the Shield of Aardwolf"                   ; @base =  750 ; original_weight = 25 # I think..
    when "Aardwolf Aura of Sanctuary"               ; @base = 2500 ; original_weight = 1
    when "the Amulet of Aardwolf"                   ; @base =  750 ; original_weight = 4
    when "Aardwolf Bracers of Iron Grip"            ; @base = 1750 ; original_weight = 0 # unknown
    when "Aardwolf Gloves of Dexterity"             ; @base = 2250 ; original_weight = 10
    when "Aardwolf Boots of Speed"                  ; @base = 1300 ; original_weight = 2
    when "Wings of Aardwolf"                        ; @base =  800 ; original_weight = 1
    when "Aardwolf Ring of Invisibility"            ; @base =  500 ; original_weight = 1
    when "Aardwolf Ring of Regeneration"            ; @base = 1000 ; original_weight = 1
    when "Aardwolf Helm of True Sight"              ; @base = 1100 ; original_weight = 5
    when "Aardwolf Breastplate of magic resistance" ; @base = 2000 ; original_weight = 10
    when "Decanter of Endless Water"                ; @base =  550 ; original_weight = 0 # unknown
    when "Bag of Aardwolf"                          ; @base = 1500 ; original_weight = 0 # depends on level.
  end

  def weight_check(original_weight, current_weight)
    if original_weight != current_weight then pprint "weight has changed: #{original_weight} => #{current_weight}" end

    # TODO: Make this much more universal.. loop through and figure out how many times I can divide by 2 or multiply by 2..
    if current_weight < original_weight then
      if current_weight <= (original_weight /  2) then pprint "half-weighted (1 time)"    ; return  2 end
      if current_weight <= (original_weight /  4) then pprint "half-weighted (2 times)"   ; return  4 end
      if current_weight <= (original_weight /  8) then pprint "half-weighted (3 times)"   ; return  6 end
      if current_weight <= (original_weight / 16) then pprint "half-weighted (4 times)"   ; return  8 end
      if current_weight <= (original_weight / 32) then pprint "half-weighted (5 times)"   ; return 10 end
      if current_weight <= (original_weight / 64) then pprint "half-weighted (6 times)"   ; return 12 end
    elsif current_weight > original_weight then
      if current_weight >= (original_weight * 64) then pprint "double-weighted (6 times)" ; return 12 end
      if current_weight >= (original_weight * 32) then pprint "double-weighted (5 times)" ; return 10 end
      if current_weight >= (original_weight * 16) then pprint "double-weighted (4 times)" ; return  8 end
      if current_weight >= (original_weight *  8) then pprint "double-weighted (3 times)" ; return  6 end
      if current_weight >= (original_weight *  4) then pprint "double-weighted (2 times)" ; return  4 end
      if current_weight >= (original_weight *  2) then pprint "double-weighted (1 time)"  ; return  2 end
    else return 0
    end
    pprint "ERROR: 'weight_check' can't deal with numbers like that.\n       current_weight = '#{current_weight}' and original_weight = '#{original_weight}'"
  end

  # Items which were renamed will bypass the above switch.  Catch the proper base value of these items.
  # Check if the damage type, flag or weight has been changed from the default.  NOTE: Items which have been renamed will slip through this net.
  case @type
    when "axe"
      base = 1000
      if original_type != "axe"      then pprint "weapon type changed" ; @tps += 3 end
      if base_flag != "vorpal"       then pprint "weapon flag changed" ; @tps += 2 end
      @tps += weight_check(original_weight, 20)
    when "dagger"
      base = 1000
      if original_type != "dagger"   then pprint "weapon type changed" ; @tps += 3 end
      if base_flag != "sharp"        then pprint "weapon flag changed" ; @tps += 2 end
      @tps += weight_check(original_weight, 10)
    when "flail"
      base = 1000
      if original_type != "flail"    then pprint "weapon type changed" ; @tps += 3 end
      if base_flag != "vampiric"     then pprint "weapon flag changed" ; @tps += 2 end
      @tps += weight_check(original_weight, 25)
    when "polearm"
      base = 1000
      if original_type != "polearm"  then pprint "weapon type changed" ; @tps += 3 end
      if base_flag != "changing"     then pprint "weapon flag changed" ; @tps += 2 end
      @tps += weight_check(original_weight, 25)
    when "mace"
      base = 1000
      if original_type != "mace"     then pprint "weapon type changed" ; @tps += 3 end
      if base_flag != "frost"        then pprint "weapon flag changed" ; @tps += 2 end
      @tps += weight_check(original_weight, 20)
    when "spear"
      base = 1000
      if original_type != "spear"    then pprint "weapon type changed" ; @tps += 3 end
      if base_flag != "shocking"     then pprint "weapon flag changed" ; @tps += 2 end
      @tps += weight_check(original_weight, 15)
    when "sword"
      base = 1000
      if original_type != "sword"    then pprint "weapon type changed" ; @tps += 3 end
      if base_flag != "flaming"      then pprint "weapon flag changed" ; @tps += 2 end
      @tps += weight_check(original_weight, 35)
    when "whip"
      base = 1000
      if original_type != "whip"     then pprint "weapon type changed" ; @tps += 3 end
      if base_flag != "vampiric"     then pprint "weapon flag changed" ; @tps += 2 end
      @tps += weight_check(original_weight, 15)
    else # non-Aard-weapons
      @tps += weight_check(original_weight, @weight)
  end # case @type
end # rbid_tp_checker


#
# Identifying equipment
#

def id
  conf.remote_triggers[/^\| Names      : (.+)\|$/] = Proc.new do |inwin, outwin, match| @names = match[1].rstrip end
  conf.remote_triggers[/^\| Desc       : (.+)\|$/] = Proc.new do |inwin, outwin, match| @desc  = match[1].rstrip end
  conf.remote_triggers[/^\| Type       : (.+)Level  :\s*(\d+)\s*\|$/] = Proc.new do |inwin, outwin, match| @type = match[1].rstrip ; @level = match[2] end
  conf.remote_triggers[/^\| Worth      :\s*(.+)\s*Weight :\s*(\d+)\s*\|$/] = Proc.new do |inwin, outwin, match|
    @worth = match[1].gsub(",", "").rstrip.to_i
    @weight = match[2].to_i
  end
  conf.remote_triggers[/^\| Wearable   :\s*(.+)\|$/] = Proc.new do |inwin, outwin, match| @wearable = match[1].rstrip end
  conf.remote_triggers[/^\| Flags      :\s*(.+)\|$/] = Proc.new do |inwin, outwin, match| @flags = match[1].rstrip end
  # FIXME: Work with additional rows of flags..
  conf.remote_triggers[/^\| Armor      : Pierce    :\s*(\d+)\s*Bash      :\s*(\d+)\s*\|$/] = Proc.new do |inwin, outwin, match| @pierce = match[1].rstrip ; @bash = match[2] end
  conf.remote_triggers[/^\|              Slash     :\s*(\d+)\s*Magic     :\s*(\d+)\s*\|$/] = Proc.new do |inwin, outwin, match| @slash = match[1].rstrip ; @magic = match[2] end

  # Hijack the next prompt:
  conf.remote_triggers[$prompt] = Proc.new do
    id_teardown
  end
  # Also write out the string, if this method was called from a local trigger.
  true
end

def id_teardown
  # All of this should fire off on the bottom border.  The bottom border is seen once, or twice, depending on the type of item:
  # Not supported: Colour in @names
  pprint @names
  pprint @desc
  pprint @type
  pprint @level
  pprint @worth
  pprint @weight
  pprint @wearable
  pprint @flags
  if @type == "Armor" then
    pprint @pierce
    pprint @bash
    pprint @slash
    pprint @magic
  end

  conf.remote_triggers.delete(/^\| Names      : (.+)\|$/)
  conf.remote_triggers.delete(/^\| Desc       : (.+)\|$/)
  conf.remote_triggers.delete(/^\| Type       : (.+)Level  :\s*(\d+)\s*\|$/)
  conf.remote_triggers.delete(/^\| Worth      :\s*(\d+)\s*Weight :\s*(\d+)\s*\|$/)
  conf.remote_triggers.delete(/^\| Wearable   :\s*(.+)\|$/)
  conf.remote_triggers.delete(/^\| Flags      :\s*(.+)\|$/)
  # FIXME: Work with additional rows of flags..
  conf.remote_triggers.delete(/^\| Armor      : Pierce    :\s*(\d+)\s*Bash      :\s*(\d+)\s*\|$/)
  conf.remote_triggers.delete(/^\|              Slash     :\s*(\d+)\s*Magic     :\s*(\d+)\s*\|$/)
  # Reset all of the prompts:
  prompt_triggers_setup
end


# This should be user-customized:
# There doesn't appear to be a simple way to set this.  Maybe I need to finger myself?  But then I'd have to have a user setting for the name of the character.. so why even bother?  I could just make the user set their tier manually..
$tier = 0
conf.local_triggers[/^getowned$/] = :getowned
# This won't work if an item doesn't have a "serial number" - a keyword between brackets.
def getowned
  gag_all 1
  # Janna's perfect white rose     (151412)    1 SySy             The Collective Mi
  conf.remote_triggers[/^(.*)\((\w+)\)\s+(\*|)(\d+).*$/] = Proc.new do |inwin, outwin, match|
    # Long names are chopped off by owned.
    name = match[1].rstrip
    # NOTE: This is not always a digit, as the item can be restrung to have an additional keyword in brackets.
    serial_keyword = "(#{match[2]})"
    item_level = match[4].to_i
#     pprint name.inspect
#     pprint serial_keyword.inspect
#     pprint item_level.inspect
    # Check to see if I'm a new remort.
    # if I'm level 1, and the item's level makes it wearable
    if $level == 1 && item_level <= ($level + ($tier * 10)) then
      write "echo #{name} #{serial_keyword}"
      getwear_keep(serial_keyword)
    elsif item_level == (item_level + ($tier * 10)) then
      # If I found something at my current level:
      # Names to ignore:
      case name
        when "A Bag of Aardwolf" ; nil
        when "Decanter of Endless Water" ; nil
        else
          write "echo #{name} #{serial_keyword}"
      end
      getowned_user_exceptions(serial_keyword)
    end
    # Clean up after the end of the owned list.
    conf.remote_triggers[/\[ \d+ \] owned items found\.$/] = Proc.new do
      conf.remote_triggers.delete(/^(.*)\((\w+)\)\s+(\*|)(\d+).*$/)
      conf.remote_triggers.delete(/\[ \d+ \] owned items found\.$/)
    end
  end
  write "owned"
end

# Keywords which are exceptions, e.g. for dualing:
# TODO: Now the problem here is that it may try to dual the one item before it tries to wield the first.
def getowned_user_exceptions(serial_keyword)
  case serial_keyword
    when "(example)" ; getdual_keep(serial_keyword) ; pprint "special item exception.."
    else
      getwear_keep(serial_keyword)
  end
end

__END__
