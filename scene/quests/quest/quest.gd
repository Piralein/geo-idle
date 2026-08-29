class_name QuestDisplay
extends VBoxContainer

const PROGRESSBAR: PackedScene = preload("uid://c78noxfcwiiox")

@export var title_node: Label
@export var description_node: Label
@export var conditions_list: VBoxContainer

## related quest id
var _quest_id: int = 0


## Set up new quest display
func setup(id: QuestIndex.IdIndex, data: DataContainerQuest) -> void:
	title_node.text = data.name
	description_node.text = data.description
	_quest_id = id
	for condition: QuestCondition in data.conditions:
		var condition_node: QuestDisplayConditionProgress = PROGRESSBAR.instantiate()
		condition_node.connect_condition(condition)
		condition_node.description.text = condition.get_condition_hint()
		var progress_data: Array[int] = condition.get_progress_hint()
		condition_node.update(progress_data[0], progress_data[1])
		conditions_list.add_child(condition_node)
	GameManager.observer_quest_completed.connect(check_completed)


## check if quest was completed and remove self
func check_completed(id: QuestIndex.IdIndex) -> void:
	if (_quest_id == id):
		queue_free()
