@abstract
class_name GameData
extends Node
## Abstract class for data handling
##
## Handels saving und loading data
## Contains all game data while active

## file name format
const SAVEFILE: String = "user://savegame_%s.save"

## Key of the saved mineral data in the json
const FILE_KEY_MINERAL_DATA: String = "mineral_data"

## Key of the saved location data in the json
const FILE_KEY_LOCATION_DATA: String = "location_data"

## Key of the saved npc data in the json
const FILE_KEY_NPC_DATA: String = "npc_data"

## Key of the saved quest data in the json
const FILE_KEY_QUEST_DATA: String = "quest_data"

## Default time for autosave (5 minutes)
const AUTOSAVE_TIME_DEFAULT: float = 300.0

## Main Menu Scene (Packetscene doesn't work?)
const MAIN_MENU: String = "uid://r8gvla5gcqec"

## Main Game Scene (Packetscene doesn't work?)
const MAIN_GAME: String = "uid://d1orxobdql0o8"

## save slot names
enum SaveSlot {
	UNIDENTIFIED = 0,
	RUBY = 1,
	SAPPHIRE = 2,
	EMERALD = 3,
}

## Timer for autosave
var autosave_timer: Timer = Timer.new()

## Currently selected save_slot
var selected_save_slot: GameData.SaveSlot = GameData.SaveSlot.UNIDENTIFIED

## Flag, is index data already loaded
var _is_loaded: bool = false

## Currently selected location
var _current_location: LocationIndex.IdIndex = LocationIndex.IdIndex.UNIDENTIFIED

## unlocked mineral id's
var minerals_unlocked: Array[MineralIndex.IdIndex]

## unlocked locations id's
var locations_unlocked: Array[LocationIndex.IdIndex]

## id's of quests currently in progress
var quest_in_progress: Array[QuestIndex.IdIndex]

## mineral data[br]
## loads base data defined in the MineralIndex[br]
## loads save_game mineral data
var mineral_data: Dictionary[MineralIndex.IdIndex, DataContainerMineral]

## location data[br]
## loads base data defined in the LocationIndex[br]
## loads save_game location data
var location_data: Dictionary[LocationIndex.IdIndex, DataContainerLocation]

## npc data[br]
## loads base data defined in the NpcIndex[br]
## loads save_game npc data
var npc_data: Dictionary[NpcIndex.IdIndex, DataContainerNpc]

## quest data[br]
## loads base data defined in the QuestIndex[br]
## loads save_game quest data
var quest_data: Dictionary[QuestIndex.IdIndex, DataContainerQuest]


## Save before quit
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		autosave_timer.stop()
		if (_is_loaded):
			save()
		get_tree().quit()


## Set up autosave
func _ready() -> void:
	autosave_timer.wait_time = AUTOSAVE_TIME_DEFAULT
	autosave_timer.timeout.connect(save)
	add_child(autosave_timer)


## Save the game to the choosen save_slot
func save() -> void:
	# Base save data
	var save_data: Dictionary = {
		"version": ProjectSettings.get_setting("application/config/version"),
		"current_location": _current_location,
		"minerals_unlocked": minerals_unlocked.size(),
		"locations_unlocked": locations_unlocked.size(),
	}
	
	# Create a Dictionary of unlocked mineral data
	# and add them to the save data
	var save_mineral_data: Dictionary = {}
	for mineral_id: MineralIndex.IdIndex in minerals_unlocked:
		var mineral: DataContainerMineral = mineral_data.get(mineral_id)
		save_mineral_data.set(mineral_id, mineral.save())
	save_data.set(FILE_KEY_MINERAL_DATA, save_mineral_data)
	
	# Create a Dictionary of unlocked location data
	# and add them to the save data
	var save_location_data: Dictionary = {}
	for location_id: LocationIndex.IdIndex in locations_unlocked:
		var location: DataContainerLocation = location_data.get(location_id)
		save_location_data.set(location_id, location.save())
	save_data.set(FILE_KEY_LOCATION_DATA, save_location_data)
	
	# Create a Dictionary of unlocked npc data
	# and add them to the save data
	var save_npc_data: Dictionary = {}
	for npc_id: NpcIndex.IdIndex in npc_data.keys():
		var npc: DataContainerNpc = npc_data.get(npc_id)
		if (npc.unlocked == true):
			save_npc_data.set(npc_id, npc.save())
	save_data.set(FILE_KEY_NPC_DATA, save_npc_data)
	
	# Create a Dictionary of unlocked quest data
	# and add them to the save data
	var save_quest_data: Dictionary = {}
	for quest_id: QuestIndex.IdIndex in quest_data.keys():
		var quest: DataContainerQuest = quest_data.get(quest_id)
		if (quest.status != DataContainerQuest.QuestStatus.LOCKED):
			save_quest_data.set(quest_id, quest.save())
	save_data.set(FILE_KEY_QUEST_DATA, save_quest_data)
	
	# Save data to file
	var save_file: FileAccess = FileAccess.open(_get_file_name(selected_save_slot), FileAccess.WRITE)
	save_file.store_line(JSON.stringify(save_data))


## Create new save
func prepare_new_save() -> void:
	assert(selected_save_slot > 0, "Save Slot not configured.")
	
	if (not _is_loaded):
		_load_mineral_index()
		_load_location_index()
		_load_npc_index()
		_load_quest_index()
		_is_loaded = true
	
	# starter town and first quest need to be unlocked by default
	# start with Fluorite as starter
	locations_unlocked.append(LocationIndex.IdIndex.DIORITE_TOWN)
	_current_location = LocationIndex.IdIndex.DIORITE_TOWN
	var first_quest: DataContainerQuest = quest_data.get(QuestIndex.IdIndex.INTRODUCTION)
	first_quest.status = DataContainerQuest.QuestStatus.ACTIVE
	quest_in_progress.append(QuestIndex.IdIndex.INTRODUCTION)
	first_quest.start()
	var gamejam_quest: DataContainerQuest = quest_data.get(QuestIndex.IdIndex.GAMEJAM)
	gamejam_quest.status = DataContainerQuest.QuestStatus.ACTIVE
	quest_in_progress.append(QuestIndex.IdIndex.GAMEJAM)
	gamejam_quest.start()
	save()


## Check if safe file exists
func save_exists(slot_id: int) -> bool:
	assert(slot_id > 0, "Save Slot not configured.")
	var file_name: String = _get_file_name(slot_id)
	return FileAccess.file_exists(file_name)


## Load save game data
func load() -> void:
	assert(selected_save_slot > 0, "Save Slot not configured.")
	
	if (not _is_loaded):
		_load_mineral_index()
		_load_location_index()
		_load_npc_index()
		_load_quest_index()
		_is_loaded = true
	
	var file_name: String = _get_file_name(selected_save_slot)
	assert(FileAccess.file_exists(file_name), "Save file doesn't exist.")

	var save_file: FileAccess = FileAccess.open(file_name, FileAccess.READ)
	var file_data: Dictionary = JSON.parse_string(save_file.get_line())
	
	# set mics values
	@warning_ignore("unsafe_cast")
	_current_location = file_data.get("current_location") as LocationIndex.IdIndex
	
	# load mineral data
	# mineral_id is of type String, because it is used as key in the json
	# cast it to int for everything not contained in the save_data
	if (file_data.has(FILE_KEY_MINERAL_DATA)):
		var save_mineral_data: Dictionary = file_data.get(FILE_KEY_MINERAL_DATA)
		for mineral_id: String in save_mineral_data:
			var mineral: DataContainerMineral = mineral_data.get(int(mineral_id))
			@warning_ignore("unsafe_call_argument")
			mineral.apply_save_data(save_mineral_data.get(mineral_id))
			minerals_unlocked.append(int(mineral_id))
	
	# load location data
	# location_id is of type String, because it is used as key in the json
	# cast it to int for everything not contained in the save_data
	if (file_data.has(FILE_KEY_LOCATION_DATA)):
		var save_location_data: Dictionary = file_data.get(FILE_KEY_LOCATION_DATA)
		for location_id: String in save_location_data:
			var location: DataContainerLocation = location_data.get(int(location_id))
			@warning_ignore("unsafe_call_argument")
			location.apply_save_data(save_location_data.get(location_id))
			locations_unlocked.append(int(location_id))
	
	# load npc data
	# npc_id is of type String, because it is used as key in the json
	# cast it to int for everything not contained in the save_data
	if (file_data.has(FILE_KEY_NPC_DATA)):
		var save_npc_data: Dictionary = file_data.get(FILE_KEY_NPC_DATA)
		for npc_id: String in save_npc_data:
			var npc: DataContainerNpc = npc_data.get(int(npc_id))
			@warning_ignore("unsafe_call_argument")
			npc.apply_save_data(save_npc_data.get(npc_id))
	
	# load quest data
	# quest_id is of type String, because it is used as key in the json
	# cast it to int for everything not contained in the save_data
	if (file_data.has(FILE_KEY_QUEST_DATA)):
		var save_quest_data: Dictionary = file_data.get(FILE_KEY_QUEST_DATA)
		for quest_id: String in save_quest_data:
			var quest: DataContainerQuest = quest_data.get(int(quest_id))
			@warning_ignore("unsafe_call_argument")
			quest.apply_save_data(save_quest_data.get(quest_id))
			if (quest.status == DataContainerQuest.QuestStatus.ACTIVE):
				quest_in_progress.append(int(quest_id))
				quest.start()


## Delete existing save
func delete_save(slot_id: int) -> void:
	DirAccess.remove_absolute(_get_file_name(slot_id))


## Return the save slot data for display
func get_save_slot_data(slot_id: int) -> Variant:
	assert(slot_id > 0, "Save Slot not configured.")
	var file_name: String = _get_file_name(slot_id)
	
	# return false, if save doesn't exist
	if (not FileAccess.file_exists(file_name)):
		return false
	
	# return base save data
	var save_file: FileAccess = FileAccess.open(file_name, FileAccess.READ)
	var file_data: Dictionary = JSON.parse_string(save_file.get_line())
	file_data.erase(FILE_KEY_MINERAL_DATA)
	return file_data


## return the save file name
func _get_file_name(slot_id: int) -> String:
	@warning_ignore("unsafe_method_access")
	return SAVEFILE % SaveSlot.find_key(slot_id).to_lower()


## Load mineral data defined in the MineralIndex
func _load_mineral_index() -> void:
	for mineral_id: int in MineralIndex.DataIndex:
		var mineral_container: DataContainerMineral = DataContainerMineral.new()
		mineral_data.set(mineral_id, mineral_container)
		@warning_ignore("unsafe_call_argument")
		mineral_container.load_index_data(mineral_id, MineralIndex.DataIndex.get(mineral_id))


## Load location data defined in the LocationIndex
func _load_location_index() -> void:
	for location_id: int in LocationIndex.DataIndex:
		var location_container: DataContainerLocation = DataContainerLocation.new()
		location_data.set(location_id, location_container)
		@warning_ignore("unsafe_call_argument")
		location_container.load_index_data(location_id, LocationIndex.DataIndex.get(location_id))


## Load npc data defined in the NpcIndex
func _load_npc_index() -> void:
	for npc_id: int in NpcIndex.DataIndex:
		var npc_container: DataContainerNpc = DataContainerNpc.new()
		npc_data.set(npc_id, npc_container)
		@warning_ignore("unsafe_call_argument")
		npc_container.load_index_data(npc_id, NpcIndex.DataIndex.get(npc_id))


## Load quest data defined in the QuestIndex
func _load_quest_index() -> void:
	for quest_id: int in QuestIndex.DataIndex:
		var quest_container: DataContainerQuest = DataContainerQuest.new()
		quest_data.set(quest_id, quest_container)
		@warning_ignore("unsafe_call_argument")
		quest_container.load_index_data(quest_id, QuestIndex.DataIndex.get(quest_id))
