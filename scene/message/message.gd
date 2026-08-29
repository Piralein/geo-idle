extends PanelContainer

@export var title_label: Label
@export var message_label: RichTextLabel

var _npc_id: int = 0
var _npc_stage: int = 0

func _ready() -> void:
	GameManager.observer_display_message.connect(display_message)


func display_message(title: String, message: String, npc_id: int, npc_stage: int) -> void:
	title_label.text = title
	message_label.text = message
	visible = true
	
	# save npc data for callback
	_npc_id = npc_id
	_npc_stage = npc_stage


func _on_confirmation_pressed() -> void:
	visible = false
	if (_npc_id > 0):
		GameManager.observer_npc_dialog.emit(_npc_id, _npc_stage)
