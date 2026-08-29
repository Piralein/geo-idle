class_name QuestConditionMineralsMined
extends QuestCondition
## quest conditions for minerals mined
##
## condition for the amount of mined minerals[br]
## at a specific location

## amount of mined minerals
var _amount_curent: int = 0

## goal amount
var _amount_goal: int = 0

## location the conditions applies to
var _location_id: LocationIndex.IdIndex = LocationIndex.IdIndex.UNIDENTIFIED


## init condition
func _init(location_id: LocationIndex.IdIndex, amount: int) -> void:
	_location_id = location_id
	_amount_goal = amount


## reset, because it is never freed
func reset() -> void:
	super()
	_amount_curent = 0


## check if the required amount was mined
func _check_requirements(location: Object = null) -> void:
	@warning_ignore("unsafe_property_access")
	if (is_instance_of(location, DataContainerLocation) && location.location_id == _location_id):
		_amount_curent += 1
		oberserver_progress_updated.emit()
		
		if (_amount_curent >= _amount_goal):
			_amount_curent = _amount_goal
			_achieved = true
			stop()
			quest_reference.observer_condition_completed.emit()


## start listening for progress updates
func start() -> void:
	if (_active || _achieved):
		return
	GameManager.observer_encounter_finished.connect(_check_requirements)
	_active = true


## stop listening for progress updates
func stop() -> void:
	if (not _active):
		return
	if (GameManager.observer_encounter_finished.is_connected(_check_requirements)):
		GameManager.observer_encounter_finished.disconnect(_check_requirements)
	_active = false


func get_condition_hint() -> String:
	return "Mine minerals"


## get progrss hint for display
func get_progress_hint() -> Array[int]:
	return [_amount_curent, _amount_goal]
