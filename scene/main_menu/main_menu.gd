extends Control
## Main Menu
##
## Handle control node interactions

## Credits(Canary) texture
@export var credits_texture: TextureRect
@export var credits_container: PanelContainer

## Exit button texture
@export var exit_button: Button
@export var exit_texture: TextureRect

# Setup
func _ready() -> void:
	# remove exit button on web
	if (OS.has_feature("web")):
		exit_button.visible = false


## hover or focus active
func _on_credits_active() -> void:
	credits_texture.material.set("shader_parameter/enabled", 1)


## hover or focus inactive
func _on_credits_inactive() -> void:
	credits_texture.material.set("shader_parameter/enabled", 0)


## credits activated
func _on_credits_pressed() -> void:
	credits_container.visible = not credits_container.visible


## hover or focus active
func _on_exit_active() -> void:
	exit_texture.material.set("shader_parameter/enabled", 1)


## hover or focus inactive
func _on_exit_inactive() -> void:
	exit_texture.material.set("shader_parameter/enabled", 0)


## exit activated
func _on_exit_pressed() -> void:
	get_tree().quit()
