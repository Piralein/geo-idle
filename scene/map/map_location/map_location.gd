class_name MapLocation
extends Button

## Location mapping
@export var location_id: LocationIndex.IdIndex

## Control to hide/show locked status
@export var locked_display: Control

## Display border for intraction
@export var interaction_border: Panel

## Display character for current location
@export var character: TextureRect

## location data
var _location_reference: DataContainerLocation = null


## set up location interaction
func _ready() -> void:
	interaction_border.visible = false
	
	character.visible = false
	GameManager.oberser_location_changed.connect(location_changed)
	GameManager.observer_location_unlocked.connect(_unlock)
	
	# disable unassigned locations
	if (location_id == LocationIndex.IdIndex.UNIDENTIFIED):
		disabled = true
		locked_display.visible = false
	else:
		_location_reference = GameManager.location_data[location_id]
		
		# highlight locked status
		if (GameManager.locations_unlocked.has(location_id)):
			locked_display.visible = false
			mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		else:
			disabled = true
			locked_display.visible = true


## Handle location change
func location_changed(id: LocationIndex.IdIndex, _data: DataContainerLocation) -> void:
	if (location_id == id):
		character.visible = true
	else:
		character.visible = false


## change location on press
func _on_pressed() -> void:
	GameManager.change_location(location_id)


## gained focus or hover
func _on_active() -> void:
	if (not disabled):
		interaction_border.visible = true


## lost focus or hover
func _on_inactive() -> void:
	if (not disabled):
		interaction_border.visible = false


## unlock region
func _unlock(id: LocationIndex.IdIndex, _data: DataContainerLocation):
	if (location_id == id):
		disabled = false
		locked_display.visible = false
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
