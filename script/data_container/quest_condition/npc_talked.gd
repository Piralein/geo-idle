class_name QuestConditionNpcTalked
extends QuestCondition
## quest conditions for npc talked
##
## condition for talking to an npc

## required npc stage
var _stage: int = -1

## location the conditions applies to
var _npc_id: NpcIndex.IdIndex = NpcIndex.IdIndex.UNIDENTIFIED


## init condition
func _init(npc_id: NpcIndex.IdIndex, stage: int = -1) -> void:
	_npc_id = npc_id
	_stage = stage


## check if the required amount was mined
func _check_requirements(npc_id: int = 0, npc_stage: int = 0) -> void:
	if (npc_id > 0 && npc_id == _npc_id):
		if (_stage == -1 || _stage == npc_stage):
			oberserver_progress_updated.emit()
			_achieved = true
			stop()
			quest_reference.observer_condition_completed.emit()


## start listening for progress updates
func start() -> void:
	if (_active || _achieved):
		return
	GameManager.observer_npc_dialog.connect(_check_requirements)
	_active = true


## stop listening for progress updates
func stop() -> void:
	if (not _active):
		return
	if (GameManager.observer_npc_dialog.is_connected(_check_requirements)):
		GameManager.observer_npc_dialog.disconnect(_check_requirements)
	_active = false


func get_condition_hint() -> String:
	return "Talk to npc"


## get progrss hint for display
func get_progress_hint() -> Array[int]:
	if (_achieved):
		return [1, 1]
	return [0, 1]
