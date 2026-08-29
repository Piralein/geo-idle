@abstract
class_name QuestCondition
extends RefCounted
## Abstract class for quest conditions
##
## provides the base api for conditions

## quest this condition is attached to
var quest_reference: DataContainerQuest

@warning_ignore("unused_signal")
signal oberserver_progress_updated

## progress gets updated
@warning_ignore("unused_private_class_variable")
var _active: bool = false

## was condition achieved
var _achieved: bool = false

## Check status of the condition
func is_achieved() -> bool:
	return _achieved


## reset, because it is never freed
func reset() -> void:
	_active = false
	_achieved = false
	quest_reference = null


@abstract
## check if requirements are met
func _check_requirements() -> void
@abstract
## start listening for progress updates
func start() -> void
@abstract
## stop listening for progress updates
func stop() -> void
@abstract
## get a display text for this condition
func get_condition_hint() -> String
@abstract
## get a display amount for this condition
func get_progress_hint() -> Array[int]
