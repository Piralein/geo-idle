extends Control

## Icon for mute button on
@export var button_mute_texture_on: Texture2D
## Icon for mute button off
@export var button_mute_texture_off: Texture2D

## mute button texture
@export var button_mute_texture: TextureRect


## set up buttons
func _ready() -> void:
	_change_mute_button_icon()


## get back to main menu
func _back_to_main_menu() -> void:
	GameManager.back_to_menu()


## toggle mute game sound on/off
func _on_mute_pressed() -> void:
	GameManager.muted = not GameManager.muted
	_change_mute_button_icon()


## change icon of the mute button
func _change_mute_button_icon() -> void:
	if (GameManager.muted):
		button_mute_texture.texture = button_mute_texture_on
	else:
		button_mute_texture.texture = button_mute_texture_off
