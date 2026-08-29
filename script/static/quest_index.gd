class_name QuestIndex
extends RefCounted
## Static class containing quest definitions
##
## Custom Resources have to many problems
## just hardcode the data into a dictionary

## Id index
enum IdIndex {
	UNIDENTIFIED = 0,
	INTRODUCTION = 1,
	FIRST_STEPS = 2,
	UNLOCK_ALL_LOCATIONS = 3,
	GAMEJAM = 10000,
}

## Data index[br]
## Contains a list of all quests in the game
## with their defined data
## VERY BAD IDEA, BECAUSE THEY DON'T GET FREED
static var DataIndex: Dictionary[int, Dictionary] = {
	IdIndex.INTRODUCTION: {
		"name": "Introduction",
		"description": "Talk to Prof. Crust",
		"conditions": [
			QuestConditionNpcTalked.new(NpcIndex.IdIndex.PROFESSOR_CRUST)
		],
		"rewards": [
			QuestRewardLocationUnlock.new(LocationIndex.IdIndex.ROUTE_1),
			QuestRewardMineralUnlock.new(MineralIndex.IdIndex.FLUORITE),
			QuestRewardQuestUnlock.new(QuestIndex.IdIndex.FIRST_STEPS),
		]
	},
	IdIndex.FIRST_STEPS: {
		"name": "First Steps",
		"description": "Mine 10 minerals on route 1",
		"conditions": [
			QuestConditionMineralsMined.new(LocationIndex.IdIndex.ROUTE_1, 10)
		],
		"rewards": [
			QuestRewardLocationUnlock.new(LocationIndex.IdIndex.ROUTE_2),
			QuestRewardQuestUnlock.new(QuestIndex.IdIndex.UNLOCK_ALL_LOCATIONS),
			QuestRewardNpcStageChange.new(NpcIndex.IdIndex.PROFESSOR_CRUST, 1)
		],
	},
	IdIndex.UNLOCK_ALL_LOCATIONS: {
		"name": "Rest of the region",
		"description": "Collect 4 different minerals\n to unlock the rest of the region",
		"conditions": [
			QuestConditionMineralsCollected.new(4),
		],
		"rewards": [
			QuestRewardLocationUnlock.new(LocationIndex.IdIndex.ROUTE_3),
			QuestRewardLocationUnlock.new(LocationIndex.IdIndex.ROUTE_4),
			QuestRewardLocationUnlock.new(LocationIndex.IdIndex.GRANITE_CITY),
		],
	},
	IdIndex.GAMEJAM: {
		"name": "GameDevDD Jam #2",
		"description": "Collect all available minerals",
		"conditions": [
			QuestConditionMineralsCollected.new(12),
		],
		"rewards": [
			QuestRewardMessage.new("GameDevDD Jam #2", "You completed the game.[br][br]Thank you for playing!"),
			QuestRewardNpcStageChange.new(NpcIndex.IdIndex.PROFESSOR_CRUST, 2),
		],
	},
}
