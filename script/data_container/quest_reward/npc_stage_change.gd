class_name QuestRewardNpcStageChange
extends QuestReward
## quest reward for changing an npc stage
##
## change the current stage of an npc dialog

## id of the npc to unlock
var _npc_id: NpcIndex.IdIndex = NpcIndex.IdIndex.UNIDENTIFIED

## stage it will change to
var _stage: int = 0


## init reward
func _init(npc_id: NpcIndex.IdIndex, stage: int) -> void:
	_npc_id = npc_id
	_stage = stage


## change stage
func get_reward() -> void:
	assert(GameManager.npc_data.has(_npc_id), "Npc data for %s is missing in GameManager." % _npc_id)
	var npc: DataContainerNpc = GameManager.npc_data.get(_npc_id)
	npc.stage = _stage
