class_name DataContainerNpc
extends RefCounted
## Static class containing npc data
##
## Serializes data for run time usage, for saving
## and is used to handle all npc related functionality
## like dialog stages

## Fallback icon[br]
## used if no icon is defined 
const FALLBACKICON: Texture2D = preload("uid://nupv21mwyg36")

# Index Data

## Display name of the npc
var name: String = "unidentified"

## Display icon for the npc
var icon: Texture2D

## Internal npc id[br]
## used for scaling
var npc_id: NpcIndex.IdIndex = NpcIndex.IdIndex.UNIDENTIFIED

## available dialog
var dialog: Dictionary[int, String]

# Save Data

## Unlock status[br]
## locked npc can't be talked to
var unlocked: bool = false

## Dialog stage[br]
## current progress of the dialog
var stage: int = 0


# Functionality


## Display dialog message
func display_dialog() -> void:
	assert(dialog.has(stage), "Dialog data of stage: %s is missing in npc: %s." % [stage, npc_id])
	GameManager.observer_display_message.emit(name, dialog.get(stage), npc_id, stage)


# Data handling


## Return all member variables as an dictionary for saving
func save() -> Dictionary:
	return {
		"unlocked": unlocked,
		"stage": stage,
	}


## Load the given save game data into the container
func apply_save_data(npc_data: Dictionary) -> void:
	unlocked = npc_data.get("unlocked")
	@warning_ignore("unsafe_call_argument")
	stage = int(npc_data.get("stage"))


## Take an entry of NpcIndex.DataIndex
## and initialize the member variables with this values
func load_index_data(index_id: int, index_data: Dictionary) -> void:
	assert(index_data.has("name"), "Index data \"Name\" is missing in %s." % index_id)
	name = index_data.get("name")
	
	assert(index_data.has("icon"), "Index data \"icon\" is missing in %s." % index_id)
	var _icon: String = index_data.get("icon")
	if (_icon != ""):
		icon = load(_icon)
	else:
		icon = FALLBACKICON
	
	npc_id = index_id as NpcIndex.IdIndex
	
	assert(index_data.has("unlock_required"), "Index data \"unlock_required\" is missing in %s." % index_id)
	if (index_data.get("unlock_required") == false):
		unlocked = true
	
	assert(index_data.has("dialog"), "Index data \"Dialog\" is missing in %s." % index_id)
	# Trying to assign a dictionary of type "Dictionary" to a variable of type "Dictionary[int, String]".
	# what?
	var _dialog: Dictionary = index_data.get("dialog")
	for key: int in _dialog.keys():
		dialog.set(key, _dialog.get(key))
