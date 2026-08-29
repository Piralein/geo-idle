class_name DataContainerQuest
extends RefCounted
## Static class containing quest data
##
## Serializes data for run time usage, for saving
## and is used to handle all quest related functionality

## quest status
enum QuestStatus {
	LOCKED = 0,
	ACTIVE = 1,
	COMPLETED = 2,
}

## an condition has completed
signal observer_condition_completed

# Index Data

## own id
var _id: QuestIndex.IdIndex = QuestIndex.IdIndex.UNIDENTIFIED

## Display name of the quest
var name: String = "unidentified"

## Display description of the quest
var description: String = "unidentified"

## conditions for this quest
var conditions: Array[QuestCondition]

## rewards for this quest
var rewards: Array[QuestReward]

# Save Data

## Unlock status[br]
## is quest locked, active or completed
var status: QuestStatus = QuestStatus.LOCKED


# Functionality


## start the quest
func start() -> void:
	if (status == QuestStatus.LOCKED):
		status = QuestStatus.ACTIVE
	if (status != QuestStatus.COMPLETED):
		for condition: QuestCondition in conditions:
			condition.start()
	observer_condition_completed.connect(check_conditions)


## stop all progress updates
func stop() -> void:
	for condition: QuestCondition in conditions:
		condition.stop()


## remove conditions
func clear() -> void:
	for condition: QuestCondition in conditions:
		condition.reset()


## check if quest was completed
func check_conditions() -> void:
	if (status != QuestStatus.ACTIVE):
		return
	
	var completed: bool = true
	for condition: QuestCondition in conditions:
		if (not condition.is_achieved()):
			completed = false
	
	if (completed):
		stop()
		for reward: QuestReward in rewards:
			reward.get_reward()
		status = QuestStatus.COMPLETED
		GameManager.observer_quest_completed.emit(_id)


# Data handling


## Return all member variables as an dictionary for saving
func save() -> Dictionary:
	return {
		"status": status,
	}


## Load the given save game data into the container
func apply_save_data(quest_data: Dictionary) -> void:
	@warning_ignore("unsafe_call_argument")
	status = int(quest_data.get("status")) as QuestStatus


## Take an entry of QuestIndex.DataIndex
## and initialize the member variables with this values
func load_index_data(index_id: int, index_data: Dictionary) -> void:
	assert(index_data.has("name"), "Index data \"Name\" is missing in %s." % index_id)
	name = index_data.get("name")
	
	assert(index_data.has("description"), "Index data \"Description\" is missing in %s." % index_id)
	description = index_data.get("description")
	
	_id = index_id as QuestIndex.IdIndex
	
	assert(index_data.has("conditions"), "Index data \"Conditions\" is missing in %s." % index_id)
	var _conditions: Array = index_data.get("conditions")
	for condition: QuestCondition in _conditions:
		conditions.append(condition)
		condition.quest_reference = self
	
	assert(index_data.has("rewards"), "Index data \"Rewards\" is missing in %s." % index_id)
	var _rewards: Array = index_data.get("rewards")
	for reward: QuestReward in _rewards:
		rewards.append(reward)
