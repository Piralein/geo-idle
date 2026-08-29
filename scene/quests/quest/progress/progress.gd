class_name QuestDisplayConditionProgress
extends ProgressBar

@export var _progress: Label
@export var description: Label

var _condition: QuestCondition

## connect to condition update
func connect_condition(condition: QuestCondition) -> void:
	_condition = condition
	_condition.oberserver_progress_updated.connect(_update_after_progress)


## TODO do better, just want to finish...
func _update_after_progress() -> void:
	var data: Array[int] = _condition.get_progress_hint()
	update(data[0], data[1])


## update the display value
func update(_value: int, _max_value: int) -> void:
	_progress.text = str(_value) + " / " + str(_max_value)
	value = _value
	max_value = _max_value
