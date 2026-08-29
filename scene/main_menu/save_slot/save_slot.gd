extends Control
## Save Slot
##
## Handle loading a saved game, or create a new one

## Background image for slot ruby
const BACKGROUND_RUBY: Texture2D = preload("uid://cvx16omg548fv")
## Background image for slot sapphire
const BACKGROUND_SAPPHIRE: Texture2D = preload("uid://c6uk36jffigwo")
## Background image for slot emerald
const BACKGROUND_EMERALD: Texture2D = preload("uid://dy3lo24b7t0br")

## Text for new game button
const NEW_GAME_TEXT: String = "New Game"

## Save slot type
@export var slot: GameData.SaveSlot = GameData.SaveSlot.UNIDENTIFIED

## Slot Nodes
@export var slot_button: Button
@export var slot_texture: TextureRect
@export var slot_label: Label

## Delete Nodes
@export var delete_button: Button
@export var delete_texture: TextureRect


## Load save slot data and display them
func _ready() -> void:
	match slot:
		GameData.SaveSlot.RUBY:
			slot_texture.texture = BACKGROUND_RUBY
		GameData.SaveSlot.SAPPHIRE:
			slot_texture.texture = BACKGROUND_SAPPHIRE
		GameData.SaveSlot.EMERALD:
			slot_texture.texture = BACKGROUND_EMERALD
	
	var slot_data = GameManager.get_save_slot_data(slot)
	if (not slot_data):
		slot_label.text = NEW_GAME_TEXT
		delete_button.visible = false
	else:
		@warning_ignore("unsafe_method_access", "unsafe_call_argument")
		slot_label.text = "Geodex: " + str(int(slot_data.get("minerals_unlocked")))


## hover or focus active
func _on_slot_active() -> void:
	slot_texture.material.set("shader_parameter/enabled", 1)


## hover or focus active
func _on_delete_active() -> void:
	delete_texture.material.set("shader_parameter/enabled", 1)


## hover or focus inactive
func _on_slot_inactive() -> void:
	slot_texture.material.set("shader_parameter/enabled", 0)


## hover or focus inactive
func _on_delete_inactive() -> void:
	delete_texture.material.set("shader_parameter/enabled", 0)


## Load existing save, otherwise create a new one, than start game
func _on_slot_pressed() -> void:
	slot_button.disabled = true
	GameManager.selected_save_slot = slot
	
	if (GameManager.save_exists(slot)):
		GameManager.load()
	else:
		GameManager.prepare_new_save()
	
	await GameManager.start_game()


## Delete existing save
func _on_delete_pressed() -> void:
	delete_button.disabled = true
	GameManager.delete_save(slot)
	slot_label.text = NEW_GAME_TEXT
	delete_button.visible = false
