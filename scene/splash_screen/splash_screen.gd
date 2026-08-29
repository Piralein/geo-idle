extends Control
## Bootsplash of the game
##
## Show Godot logo and transition to main scene

## Main menu scene
const MAIN_MENU: PackedScene = preload("uid://r8gvla5gcqec")

## Nodes
@export var animation_player: AnimationPlayer
@export var end_timer_node: Timer

## Transition to other icon and start end_timer
func _on_transition_timer_timeout() -> void:
	animation_player.play("logo_transition")
	end_timer_node.start()


## Load main menu scene
func _on_end_timer_timeout() -> void:
	get_tree().change_scene_to_packed(MAIN_MENU)
