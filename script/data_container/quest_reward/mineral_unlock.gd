class_name QuestRewardMineralUnlock
extends QuestReward
## quest reward for minerals unlock
##
## unlocks a mineral

## id of the mineral to unlock
var _mineral_id: MineralIndex.IdIndex = MineralIndex.IdIndex.UNIDENTIFIED


## init reward
func _init(mineral_id: MineralIndex.IdIndex) -> void:
	_mineral_id = mineral_id


## get mineral unlock
func get_reward() -> void:
	GameManager.unlock_mineral(_mineral_id)
