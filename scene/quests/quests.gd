extends PanelContainer

const QUEST: PackedScene = preload("uid://bruuhftr5f7lh")

@export var quest_list: VBoxContainer


func _ready() -> void:
	for quest_id: QuestIndex.IdIndex in GameManager.quest_in_progress:
		var quest: DataContainerQuest = GameManager.quest_data.get(quest_id)
		add_quest(quest_id, quest)
	GameManager.observer_quest_unlocked.connect(add_quest)


## Add new quest to the quest list
func add_quest(id: QuestIndex.IdIndex, data: DataContainerQuest) -> void:
	var quest_node: QuestDisplay = QUEST.instantiate()
	quest_node.setup(id, data)
	quest_list.add_child(quest_node) 
