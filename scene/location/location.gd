extends Control
## Location tab
##
## Display battles and landmark interactions

## button for npc dialog
const NPC_BUTTON: PackedScene = preload("uid://dbo7axgai2wml")

@export_group("Location Data", "location")

## Background image of this location
@export var location_background: TextureRect

## Display for the location name
@export var location_name: Label

## Display for the location meta data[br]
## like amount of mined minerals
@export var location_meta: Label

@export_group("Encounter", "encounter")

## Hide/Show the entire encounter panel
@export var encounter_toolbar: PanelContainer

## Name of the encountered mineral
@export var encounter_name: Label

## Icon of the encounter
@export var encounter_icon: TextureRect

## Overlay icon for locked encounter
@export var encounter_icon_locked: TextureRect

## Overlay icon for prospecting
@export var encounter_icon_prospect: TextureRect

## Chance dislay for prospecting
@export var encounter_prospect_chance: Label

## AnimationPlayer for prospecting
@export var encounter_prospect_animation: AnimationPlayer

## Health bar of the encounter
@export var encounter_health_bar: ProgressBar

## Health bar label of the encounter
@export var encounter_health_bar_label: Label

## Tween for health bar animation
var _encounter_health_bar_tween: Tween

## Store the intermediate value for animation
var _encounter_health_bar_intermediate_value: int = 0

@export_group("Landmark", "landmark")

## Hide/Show the entire landmark panel
@export var landmark_toolbar: PanelContainer

## Npc list
@export var landmark_npc_list: VBoxContainer


## Set up all connections
func _ready() -> void:
	GameManager.oberser_location_changed.connect(prepare_location)
	GameManager.observer_encounter_started.connect(prepare_encounter)
	GameManager.observer_encounter_damaged.connect(update_encounter)
	GameManager.observer_encounter_prospect.connect(prospect_encounter)
	GameManager.observer_encounter_finished.connect(finish_encounter)


## Update the display to show the new location data[br]
## Show different parts of the UI depending on the type of location
func prepare_location(_id: LocationIndex.IdIndex, data: DataContainerLocation) -> void:
	location_name.text = data.name
	location_background.texture = data.background
	
	match data.type:
		Constants.LocationType.BATTLE_ZONE:
			landmark_toolbar.visible = false
			location_meta.visible = true
			encounter_toolbar.visible = true
			location_meta.text = str(data.mined_minerals) + " minerals mined"
		Constants.LocationType.LANDMARK:
			location_meta.visible = false
			encounter_toolbar.visible = false
			landmark_toolbar.visible = true
			prepare_landmark(data)


## Add landmark information
func prepare_landmark(data: DataContainerLocation) -> void:
	# clear list
	for child: Button in landmark_npc_list.get_children():
		child.visible = false
		child.queue_free()
	
	# add new npc data
	for npc_id: int in data.npc_ids:
		var npc: DataContainerNpc = GameManager.npc_data.get(npc_id)
		if (npc.unlocked == true):
			var npc_button: Button = NPC_BUTTON.instantiate()
			npc_button.text = npc.name
			npc_button.pressed.connect(npc.display_dialog)
			landmark_npc_list.add_child(npc_button)


## Display encounter information
func prepare_encounter(mineral_id: MineralIndex.IdIndex, hp: int) -> void:
	# reset animation
	if (_encounter_health_bar_tween and _encounter_health_bar_tween.is_valid()):
		_encounter_health_bar_tween.kill()
	
	# health bar setup
	encounter_health_bar.max_value = float(hp)
	encounter_health_bar.value = encounter_health_bar.max_value
	encounter_health_bar.visible = true
	encounter_icon_prospect.visible = false
	encounter_prospect_chance.visible = false
	encounter_health_bar_label.text = str(encounter_health_bar.value) + " / " + str(encounter_health_bar.max_value)
	
	# icon setup
	encounter_icon.texture = GameManager.mineral_data[mineral_id].icon
	if (not GameManager.minerals_unlocked.has(mineral_id)):
		encounter_icon.self_modulate = Color.BLACK
		encounter_icon_locked.visible = true
		encounter_name.text = "unknown"
	else:
		encounter_icon.self_modulate = Color.WHITE
		encounter_icon_locked.visible = false
		encounter_name.text = GameManager.mineral_data[mineral_id].name


## Update encounter health bar values[br]
## Use a tween to get a smooth ProgressBar change
func update_encounter(hp: int) -> void:
	_encounter_health_bar_intermediate_value = hp
	
	# faster for smaller numbers, otherwise its not smooth
	var delay: float = 0.5
	if (encounter_health_bar.value - hp <= 8):
		delay = 0.2
	
	if (_encounter_health_bar_tween and _encounter_health_bar_tween.is_valid()):
		_encounter_health_bar_tween.kill()
	_encounter_health_bar_tween = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_encounter_health_bar_tween.tween_method(
		_set_encounter_health_bar_value,
		encounter_health_bar.value,
		_encounter_health_bar_intermediate_value,
		delay
	)
	
	encounter_health_bar_label.text = str(hp) + " / " + str(encounter_health_bar.max_value)


## Set the current health bar value
func _set_encounter_health_bar_value(hp: int) -> void:
	encounter_health_bar.value = hp


## Play animation for prospecting attempt
func prospect_encounter(prospect_chance: int) -> void:
	encounter_prospect_chance.text = str(prospect_chance) + "% chance"
	
	encounter_icon_prospect.visible = true
	encounter_health_bar.visible = false
	encounter_prospect_chance.visible = true
	
	var loops: int = 3
	while(loops > 0):
		encounter_prospect_animation.play("circle")
		await encounter_prospect_animation.animation_finished
		loops -= 1
	
	# make sure the emit is called after possible awaits connecting to it
	# needed then not already deffered by its own await
	GameManager.observer_encounter_prospect_animation_finished.emit.call_deferred()


## Handle different types of data updates
func finish_encounter(dataContainer: Object) -> void:
	# location encounter
	if (is_instance_of(dataContainer, DataContainerLocation)):
		@warning_ignore("unsafe_property_access")
		location_meta.text = str(dataContainer.mined_minerals) + " minerals mined"
	# add new encounter here
