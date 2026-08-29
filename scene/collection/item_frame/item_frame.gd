class_name ItemFrame
extends Panel
## Display a mineral

## Name display
@export var mineral_name: Label

## Id display
@export var mineral_id: Label

## Icon display
@export var _icon: TextureRect

## The mineral group
var mineral_group: Constants.MineralGroup = Constants.MineralGroup.UNIDENTIFIED


## Setter for mineral data by id
func setup(id: int, data: DataContainerMineral) -> void:
	mineral_id.text = str(id)
	mineral_name.text = data.name
	_icon.texture = data.icon
	mineral_group = data.mineral_group
