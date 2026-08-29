class_name DataContainerLocation
extends RefCounted
## Static class containing location data
##
## Serializes data for run time usage, for saving
## and is used to handle all location related functionality
## like picking a mineral for an encounter

## Fallback background[br]
## used if no background is defined 
const FALLBACKBACKGROUND: Texture2D = preload("uid://derh77pxsoets")

# Index Data

## Display name of the location
var name: String = "unidentified"

## Display background for the location
var background: Texture2D

## Internal location id[br]
## used for scaling
var location_id: LocationIndex.IdIndex = LocationIndex.IdIndex.UNIDENTIFIED

## Type of location[br]
## Defines the feature set, like encounters and landmarks
var type: Constants.LocationType = Constants.LocationType.UNIDENTIFIED

## Minerals available at this location
var minerals: Array[MineralIndex.IdIndex]

## Calculated HP values for this location
var minerals_hp: Dictionary[MineralIndex.IdIndex, int]

## Calculated avarage of all mineral base hp values
var avarage_minerals_hp: float = -1.0

## npc's at this location
var npc_ids: Array[int]

# Save Data

## Unlock status[br]
## locked locations can't be accessed or viewed
var unlocked: bool = false

## Amount of mined(killed) minerals
var mined_minerals: int = 0


# Location functionality


## Return a random mineral[br]
## uniform random selection for now
func get_next_encounter() -> Array[int]:
	assert(minerals.size() > 0, 'Next encounter of \"%s\" not possible, data missing' % name)
	var mineral_id: int = minerals.pick_random()
	return [mineral_id, minerals_hp[mineral_id]]


## Encounter was defeated[br]
## increment the [member mined_minerals] counter
func process_encounter_finished(mineral_id: MineralIndex.IdIndex) -> void:
	mined_minerals += 1
	
	# only unlock locked minerals for now, because scope q.q
	if (not GameManager.minerals_unlocked.has(mineral_id)):
		var prospecting_chance: int = GameManager.mineral_data[mineral_id].get_prospecting_chance()
		GameManager.observer_encounter_prospect.emit(prospecting_chance)
		await GameManager.observer_encounter_prospect_animation_finished
		if (randi_range(1, 100) < prospecting_chance):
			GameManager.unlock_mineral(mineral_id)
	
	# calculate after unlock
	GameManager.calculate_damage()
	GameManager.observer_encounter_finished.emit(self)


## Calculate the location specific HP value of a given mineral
func _calculate_mineral_hp(mineral_id: MineralIndex.IdIndex) -> int:
	var mineral_data: DataContainerMineral = GameManager.mineral_data[mineral_id]
	
	# base hp = hardness * specific_gravity
	var base_hp: float = float(mineral_data.hardness * mineral_data.specific_gravity)
	
	# calculate avarage if not already calculated
	if (avarage_minerals_hp == -1.0):
		var avarage: float = 0.0
		for avg_mineral_id: MineralIndex.IdIndex in minerals:
			var avg_mineral_data: DataContainerMineral = GameManager.mineral_data[avg_mineral_id]
			avarage += float(avg_mineral_data.hardness * avg_mineral_data.specific_gravity)
		avarage_minerals_hp = avarage / float(minerals.size())
	
	# modifier based on location_id, starts at 1 and goes up by 1 for each route
	var location_modifier: float = 20 + 20 * pow(location_id, 1.2)
	
	return roundi(location_modifier * (0.9 + 0.1 * base_hp / avarage_minerals_hp))


# Data handling


## Return all member variables as an dictionary for saving
func save() -> Dictionary:
	return {
		"mined_minerals": mined_minerals,
	}


## Load the given save game data into the container
func apply_save_data(location_data: Dictionary) -> void:
	@warning_ignore("unsafe_call_argument")
	mined_minerals = int(location_data.get("mined_minerals"))


## Take an entry of LocationIndex.DataIndex
## and initialize the member variables with this values
func load_index_data(index_id: int, index_data: Dictionary) -> void:
	assert(index_data.has("name"), "Index data \"Name\" is missing in %s." % index_id)
	name = index_data.get("name")
	
	assert(index_data.has("background"), "Index data \"background\" is missing in %s." % index_id)
	var _background: String = index_data.get("background")
	if (_background != ""):
		background = load(_background)
	else:
		background = FALLBACKBACKGROUND
	
	assert(index_data.has("type"), "Index data \"Type\" is missing in %s." % index_id)
	type = index_data.get("type")
	
	location_id = index_id as LocationIndex.IdIndex
	
	if (type == Constants.LocationType.BATTLE_ZONE):
		assert(index_data.has("minerals"), "Index data \"Minerals\" is missing in %s." % index_id)
		for mineral_id: MineralIndex.IdIndex in index_data.get("minerals"):
			minerals.append(mineral_id)
			minerals_hp.set(mineral_id, _calculate_mineral_hp(mineral_id))
	
	if (type == Constants.LocationType.LANDMARK):
		assert(index_data.has("npc_ids"), "Index data \"Npc Ids\" is missing in %s." % index_id)
		for npc_id: NpcIndex.IdIndex in index_data.get("npc_ids"):
			npc_ids.append(npc_id)
