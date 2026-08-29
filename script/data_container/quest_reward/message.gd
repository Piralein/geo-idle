class_name QuestRewardMessage
extends QuestReward
## quest reward for message
##
## display a custom reward message

## custom message title
var _title: String

## custom message text
var _message: String


## init reward
func _init(title: String, message: String) -> void:
	_title = title
	_message = message


## show message
func get_reward() -> void:
	GameManager.observer_display_message.emit(_title, _message, 0, 0)
