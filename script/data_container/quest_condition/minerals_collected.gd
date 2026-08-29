class_name QuestConditionMineralsCollected
extends QuestCondition
## quest conditions for minerals collected
##
## condition for the amount of collected minerals

## goal amount
var _amount_goal: int = 0

## init condition
func _init(amount: int) -> void:
	_amount_goal = amount


## check if the required amount was mined
func _check_requirements(_id: MineralIndex.IdIndex = MineralIndex.IdIndex.UNIDENTIFIED, _data: DataContainerMineral = null) -> void:
	oberserver_progress_updated.emit()
	if (GameManager.minerals_unlocked.size() >= _amount_goal):
		_achieved = true
		stop()
		quest_reference.observer_condition_completed.emit()


## start listening for progress updates
func start() -> void:
	if (_active || _achieved):
		return
	GameManager.observer_mineral_unlocked.connect(_check_requirements)
	_active = true


## stop listening for progress updates
func stop() -> void:
	if (not _active):
		return
	if (GameManager.observer_mineral_unlocked.is_connected(_check_requirements)):
		GameManager.observer_mineral_unlocked.disconnect(_check_requirements)
	_active = false


func get_condition_hint() -> String:
	return "Collect minerals"


## get progrss hint for display
func get_progress_hint() -> Array[int]:
	return [GameManager.minerals_unlocked.size(), _amount_goal]
