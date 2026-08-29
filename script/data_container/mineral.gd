class_name DataContainerMineral
extends RefCounted
## Static class containing mineral data
##
## Serializes data for run time usage, for saving
## and is used to handle all mineral related functionality
## like applying EXP

## Fallback icon[br]
## used if no mineral icon is defined in 
const FALLBACKICON: Texture2D = preload("uid://dbynui7krfowj")

# Index Data

## Display name of the mineral
var name: String = "unidentified"

## Display icon of the mineral
var icon: Texture2D

## Assigned mineral group[br]
## Used for sorting in the collection
var mineral_group: Constants.MineralGroup = Constants.MineralGroup.UNIDENTIFIED

## Assigned crystal system[br]
## Used for choosing the EXP calculation formula
var crystal_system: Constants.CrystalSystem = Constants.CrystalSystem.UNIDENTIFIED

## Mineral hardness[br]
## Used as attack value, and multiplier for HP
var hardness: int = 0

## Mineral specific gravity[br]
## Used base HP value
var specific_gravity: int = 0

## Prospecting Chance[br]
## calculated by prospect_rate^0.75
var prospect_rate: int = 0

# Save Data

## Unlock status[br]
## Locked minerals are not listed in the collection
## and are obfuscated in encounters
var unlocked: bool = false

## TODO Current level, based on experience
var level: int = 1

## TODO Gathered EXP
var experience: float = 0.0


# Mineral functionality


## TODO Add experience and update level
## Scaling according to Crystal System
func add_experience(exp_value: float) -> void:
	# already max level or invalid number
	if (level >= 100 || exp_value <= 0):
		return
	
	# 'Monoclinic' most common, corrolate with 'Medium Fast' 
	# 1,000,000 max EXP, n³
	if (crystal_system == Constants.CrystalSystem.MONOCLINIC):
		experience = clampf((experience + exp_value), 0.0, 1000000)
		level = clampi(floori(pow(experience, 1.0 / 3.0)), 1, 100)
	
	# 'trigonal', 'orthorhombic' and 'cubic' mid range, corrolate with 'Medium Slow' 
	# 1,059,860 max EXP, n³
	if (crystal_system == Constants.CrystalSystem.TRIGONAL
	|| crystal_system == Constants.CrystalSystem.ORTHORHOMBIC
	|| crystal_system == Constants.CrystalSystem.CUBIC):
		experience = clampf((experience + exp_value), 0.0, 1059860)
		# TODO
	
	# 'tetragonal', 'hexagonal' and 'triclinic' least common, corrolate with 'Slow' 
	# 1,250,000 max EXP, 5n³ / 4
	if (crystal_system == Constants.CrystalSystem.TETRAGONAL
	|| crystal_system == Constants.CrystalSystem.HEXAGONAL
	|| crystal_system == Constants.CrystalSystem.TRICLINIC):
		experience = clampf((experience + exp_value), 0.0, 1250000)
		level = clampi(floori(pow((4 * experience) / 5.0, 1.0 / 3.0)), 1, 100)


## Calculate the current damage based on level
func get_damage() -> int:
	# TODO implement level
	return hardness


## Calculate prospecting chance[br]
## percentage between 0 and 100[br]
## calculates a random -3 to 3 as additional variation
func get_prospecting_chance() -> int:
	return clamp(floori(pow(prospect_rate, 0.75)) + randi_range(-3, 3), 0, 100)


# Data handling


## Return all member variables as an dictionary for saving
func save() -> Dictionary:
	return {
		"experience": experience,
	}


## Load the given save game data into the container
func apply_save_data(mineral_data: Dictionary) -> void:
	@warning_ignore("unsafe_call_argument")
	experience = float(mineral_data.get("experience"))


## Take an entry of MineralIndex.DataIndex
## and initialize the member variables with this values
func load_index_data(index_id: int, index_data: Dictionary) -> void:
	assert(index_data.has("name"), "Index data \"Name\" is missing in %s." % index_id)
	name = index_data.get("name")
	
	assert(index_data.has("group"), "Index data \"Mineral Group\" is missing in %s." % index_id)
	mineral_group = index_data.get("group")

	assert(index_data.has("crystal_system"), "Index data \"Crystal System\" is missing in %s." % index_id)
	crystal_system = index_data.get("crystal_system")
	
	assert(index_data.has("icon"), "Index data \"Icon\" is missing in %s." % index_id)
	var _icon: String = index_data.get("icon")
	if (_icon != ""):
		icon = load(_icon)
	else:
		icon = FALLBACKICON

	assert(index_data.has("hardness"), "Index data \"Hardness\" is missing in %s." % index_id)
	hardness = index_data.get("hardness")
	
	assert(index_data.has("specific_gravity"), "Index data \"Specific Gravity\" is missing in %s." % index_id)
	specific_gravity = index_data.get("specific_gravity")
	
	assert(index_data.has("prospect_rate"), "Index data \"Prospect Rate\" is missing in %s." % index_id)
	prospect_rate = index_data.get("prospect_rate")
