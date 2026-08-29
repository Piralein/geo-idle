extends GameData

## Toggle visibility of the collection window
@warning_ignore("unused_signal")
signal observer_collection_toggle

## Display a message[br]
## npc_id is optional
@warning_ignore("unused_signal")
signal observer_display_message(title: String, message: String, npc_id: int, npc_stage: int)

## Display a message[br]
## npc_id is optional
@warning_ignore("unused_signal")
signal observer_npc_dialog(npc_id: int, npc_stage: int)

## New encounter was started
signal observer_encounter_started(id: MineralIndex.IdIndex, hp: int)

## Damage was dealt
signal observer_encounter_damaged(hp: int)

## Trying to prospect a mineral
@warning_ignore("unused_signal")
signal observer_encounter_prospect(prospect_chance: int)

## Animations after prospect animation finished
@warning_ignore("unused_signal")
signal observer_encounter_prospect_animation_finished

## Encounter successfully finished
@warning_ignore("unused_signal")
signal observer_encounter_finished(dataContainer: Object)

## Damage was recalculated
signal observer_damage_calculated

## Location was changed
signal oberser_location_changed(id: LocationIndex.IdIndex, data: DataContainerLocation)

## New mineral was unlocked
signal observer_mineral_unlocked(id: MineralIndex.IdIndex, data: DataContainerMineral)

## New location was unlocked
signal observer_location_unlocked(id: LocationIndex.IdIndex, data: DataContainerLocation)

## New npc was unlocked
signal observer_npc_unlocked(id: NpcIndex.IdIndex, data: DataContainerNpc)

## New quest was unlocked
signal observer_quest_unlocked(id: QuestIndex.IdIndex, data: DataContainerQuest)

## Quest was completed
signal observer_quest_completed(id: QuestIndex.IdIndex)

## Time between each damage calculation[br]
## defined in seconds
const ENCOUNTER_CALCULATION_DELAY: int = 1

## Timer for encounter damage calculations[br]
## Uses [member GameManager.ENCOUNTER_CALCULATION_DELAY] as 'wait_time'
var _encounter_calculation_timer: Timer = Timer.new()

## Id of the current encounter
var _encounter_mineral_id: MineralIndex.IdIndex = MineralIndex.IdIndex.UNIDENTIFIED

## real HP of the current encounter
var _encounter_mineral_hp: int = 0

## MAX HP of the current encounter
var _encounter_mineral_hp_max: int = 0

## Type of the current encounter[br]
## needs to be set before calling [method GameManager.start_new_encounter]
var encounter_type: Constants.BattleType = Constants.BattleType.UNIDENTIFIED

## Factory for new encounters[br]
## needs to be set before calling [method GameManager.start_new_encounter][br][br]
## Traits are not implemented until the GdScript rewrite[br][br]
## assume the class implements function 'get_next_encounter()'
## which returns an array[MineralId: MineralIndex.IdIndex, hp: int][br][br]
## assume the class implements function 'process_encounter_finished(id: MineralIndex.IdIndex)'
## which handles a successful encounter
var encounter_factory: Object = null

## Currently calculated damage value
var current_damage: int = 0

## Game muted or not
var muted: bool = false


## Set up encounter timer
func _ready() -> void:
	_encounter_calculation_timer.wait_time = ENCOUNTER_CALCULATION_DELAY
	_encounter_calculation_timer.one_shot = true
	_encounter_calculation_timer.timeout.connect(_process_encounter)
	add_child(_encounter_calculation_timer)
	observer_quest_completed.connect(_quest_completed)

	# call parent setup
	super._ready()


## Initialize a new encounter[br]
## Use the encounter factory to handle the import data
func start_new_encounter() -> void:
	match encounter_type:
		Constants.BattleType.WILD:
			# no unpacking in gdscript, use temp variable
			@warning_ignore("unsafe_method_access")
			var encounter: Array[int] = encounter_factory.get_next_encounter()
			
			assert(encounter.size() == 2, 'encounter data malformed in \"%s\"' % _current_location)
			assert(encounter[1] > 0, 'invalid encounter hp in \"%s\"' % _current_location)
			
			_encounter_mineral_id = encounter[0] as MineralIndex.IdIndex
			_encounter_mineral_hp_max = encounter[1]
			_encounter_mineral_hp = _encounter_mineral_hp_max
		# add different encounters like dungeons here
	observer_encounter_started.emit(_encounter_mineral_id, _encounter_mineral_hp)
	_encounter_calculation_timer.start()


## Handle the calculations of encounter[br]
## handles damage calculation, mining(killed) and unlock(captured)
func _process_encounter() -> void:
	_encounter_mineral_hp -= current_damage
	if (_encounter_mineral_hp <= 0):
		# defeated
		@warning_ignore("unsafe_method_access")
		await encounter_factory.process_encounter_finished(_encounter_mineral_id)
		if (encounter_type == Constants.BattleType.WILD):
			start_new_encounter()
		# add other forms of end encounter here
	else:
		# still alive, next cycle
		observer_encounter_damaged.emit(_encounter_mineral_hp)
		_encounter_calculation_timer.start()


## Calculate the current damage output
func calculate_damage() -> void:
	var damage: int = 0
	for mineral_id: MineralIndex.IdIndex in minerals_unlocked:
		damage += mineral_data[mineral_id].get_damage()
	current_damage = damage
	observer_damage_calculated.emit()


## Switch to a different location[br]
## If the location is of type Constants.LocationType.BATTLE_ZONE
## start a new encounter
func change_location(id: LocationIndex.IdIndex, force_load: bool = false) -> void:
	assert(location_data.has(id), 'Location change to \"%s\" not possible, data missing' % str(id))
	
	# not unlocked or already active
	if (not locations_unlocked.has(id)
	|| (id == _current_location && not force_load)):
		return
	
	_encounter_calculation_timer.stop()
	_current_location = id 
	
	var location: DataContainerLocation = location_data.get(id)
	oberser_location_changed.emit(id, location)
	
	# directly start encounter in battle zones
	if (location.type == Constants.LocationType.BATTLE_ZONE):
		encounter_type = Constants.BattleType.WILD
		encounter_factory = location
		start_new_encounter()


## Unlock new mineral, if not already unlocked
func unlock_mineral(id: MineralIndex.IdIndex) -> void:
	assert(mineral_data.has(id), 'Mineral unlock of \"%s\" not possible, data missing' % str(id))
	if (minerals_unlocked.has(id)):
		return
	
	var mineral: DataContainerMineral = mineral_data.get(id)
	mineral.unlocked = true
	minerals_unlocked.append(id)
	calculate_damage()
	observer_mineral_unlocked.emit(id, mineral)


## Unlock new location, if not already unlocked
func unlock_location(id: LocationIndex.IdIndex) -> void:
	assert(location_data.has(id), 'Location unlock of \"%s\" not possible, data missing' % str(id))
	if (locations_unlocked.has(id)):
		return
	
	var location: DataContainerLocation = location_data.get(id)
	location.unlocked = true
	locations_unlocked.append(id)
	observer_location_unlocked.emit(id, location)


## Unlock new npc, if not already unlocked
func unlock_npc(id: NpcIndex.IdIndex) -> void:
	assert(npc_data.has(id), 'Npc unlock of \"%s\" not possible, data missing' % str(id))
	
	var npc: DataContainerNpc = npc_data.get(id)
	if (not npc.unlocked):
		npc.unlocked = true
		observer_npc_unlocked.emit(id, npc)


## Unlock new quest, if not already unlocked
func unlock_quest(id: QuestIndex.IdIndex) -> void:
	assert(quest_data.has(id), 'Quest unlock of \"%s\" not possible, data missing' % str(id))
	
	var quest: DataContainerQuest = quest_data.get(id)
	if (quest.status == DataContainerQuest.QuestStatus.LOCKED):
		quest.status = DataContainerQuest.QuestStatus.ACTIVE
		quest_in_progress.append(id)
		quest.start()
		observer_quest_unlocked.emit(id, quest)


## remove completed quest from current quests
func _quest_completed(id: QuestIndex.IdIndex) -> void:
	quest_in_progress.erase(id)


## Start game[br]
## Change to game scene, start timers
## and initialize current location
func start_game() -> void:
	get_tree().change_scene_to_packed(load(MAIN_GAME) as PackedScene)
	# wait until main game is fully loaded and then resume
	await get_tree().scene_changed
	autosave_timer.start()
	calculate_damage()
	change_location(_current_location, true)


## Exit Game back to the main menu[br]
## Reset all run time vairables back to default
func back_to_menu() -> void:
	_encounter_calculation_timer.stop()
	autosave_timer.stop()
	
	save()
	
	# reset misc
	selected_save_slot = GameData.SaveSlot.UNIDENTIFIED
	_is_loaded = false
	
	# reset encounter
	_encounter_mineral_id = MineralIndex.IdIndex.UNIDENTIFIED
	_encounter_mineral_hp = 0
	_encounter_mineral_hp_max = 0
	encounter_type = Constants.BattleType.UNIDENTIFIED
	encounter_factory = null
	
	# reset minerals
	minerals_unlocked.clear()
	mineral_data.clear()
	
	# reset locations
	locations_unlocked.clear()
	location_data.clear()
	_current_location = LocationIndex.IdIndex.UNIDENTIFIED
	
	# reset npc's
	npc_data.clear()
	
	# reset quests
	## conditions are not reset, because they are referenced in QuestIndex
	for quest: DataContainerQuest in quest_data.values():
		quest.stop()
		quest.clear()
	quest_in_progress.clear()
	quest_data.clear()
	
	get_tree().change_scene_to_packed(load(MAIN_MENU) as PackedScene)
