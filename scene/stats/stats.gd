extends PanelContainer
## Statistic tab
##
## Display statistics

## Display amount of unlocked minerals
@export var geodex: Label

## Display current damage
@export var damage: Label

## Display collection window
@export var collection: Button


## Connect signals and initialize labels 
func _ready() -> void:
	GameManager.observer_mineral_unlocked.connect(update_geodex)
	update_geodex(MineralIndex.IdIndex.UNIDENTIFIED, null)
	GameManager.observer_damage_calculated.connect(update_damage)
	update_damage()


## Update the display amount of the geodex
func update_geodex(_id: MineralIndex.IdIndex, _data: DataContainerMineral) -> void:
	geodex.text = "Geodex: " + str(GameManager.minerals_unlocked.size())


## Update the display amount of the total damage
func update_damage() -> void:
	damage.text = "Mining Power: " + str(GameManager.current_damage)


## Open and close collection window
func _on_collection_pressed() -> void:
	GameManager.observer_collection_toggle.emit()
