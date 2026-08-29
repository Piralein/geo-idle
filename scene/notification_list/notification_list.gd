extends Control
## Notification list
##
## Display notification messages

## Notification scene
const NOTIFICATION_SCENE: PackedScene = preload("uid://djcxqud8t0q27")

## Notification sound for unlocks
const NOTIFICATION_SOUND_UNLOCK: AudioStream = preload("uid://cxm7qbrreofvf")

## Notification sound player
@export var audio_player: AudioStreamPlayer

## Notification list vBox
@export var notification_list: VBoxContainer


## Set up signals
func _ready() -> void:
	GameManager.observer_mineral_unlocked.connect(_mineral_unlocked)
	GameManager.observer_location_unlocked.connect(_location_unlocked)


# Mineral unlocked notification
func _mineral_unlocked(_id: MineralIndex.IdIndex, data: DataContainerMineral) -> void:
	var message: Notification = NOTIFICATION_SCENE.instantiate()
	message.setup("New mineral \"" + data.name + "\" collected.", Constants.NotificationType.UNLOCK)
	notification_list.add_child(message)
	if (not GameManager.muted):
		audio_player.stop()
		audio_player.stream = NOTIFICATION_SOUND_UNLOCK
		audio_player.play()


# Location unlocked notification
func _location_unlocked(_id: LocationIndex.IdIndex, data: DataContainerLocation) -> void:
	var message: Notification = NOTIFICATION_SCENE.instantiate()
	message.setup("New location \"" + data.name + "\" was unlocked.", Constants.NotificationType.UNLOCK)
	notification_list.add_child(message)
	if (not GameManager.muted):
		audio_player.stop()
		audio_player.stream = NOTIFICATION_SOUND_UNLOCK
		audio_player.play()
