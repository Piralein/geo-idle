class_name QuestRewardQuestUnlock
extends QuestReward
## quest reward for quest unlock
##
## unlocks a quest

## id of the quest to unlock
var _quest_id: QuestIndex.IdIndex = QuestIndex.IdIndex.UNIDENTIFIED


## init reward
func _init(quest_id: QuestIndex.IdIndex) -> void:
	_quest_id = quest_id


## get quest unlock
func get_reward() -> void:
	GameManager.unlock_quest(_quest_id)
