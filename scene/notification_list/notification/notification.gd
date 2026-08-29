class_name Notification
extends PanelContainer
## Notification
##
## Display notification message

## Default display time in seconds 
const TIMER_DEFAULT_DELAY: int = 6

## Message label
@export var message_label: Label

## Type of notification
var notification_type: Constants.NotificationType = Constants.NotificationType.UNIDENTIFIED

## Timer for auto hide
var _timer: Timer = Timer.new()


## Set up timer
func _ready() -> void:
	_timer.one_shot = true
	_timer.timeout.connect(queue_free)
	add_child(_timer)
	_timer.start(TIMER_DEFAULT_DELAY)


## Display the message
func setup(message: String, type: Constants.NotificationType) -> void:
	notification_type = type
	message_label.text = message
