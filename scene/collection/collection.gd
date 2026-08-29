extends Control
## Collection window of locked/unlocked minerals
##
## Handle searching, filtering and sorting

## Item Frame scene
const ITEMFRAME: PackedScene = preload("uid://ckcpuw2s3xllk")

## Amount of items displayes
var _count: int = 0

## Amount Label
@export var _count_label: Label

## Grid container
@export var _grid_container: GridContainer

## Search input
@export var _search: LineEdit

## Group select
@export var _group_select: OptionButton

## contained data
var _items: Dictionary[MineralIndex.IdIndex, ItemFrame]


## Set up filter display and item frames
func _ready() -> void:
	GameManager.observer_collection_toggle.connect(_toggle_visibility)
	
	# subscribe to unlock signal
	GameManager.observer_mineral_unlocked.connect(
		func(id: MineralIndex.IdIndex, data: DataContainerMineral):
			add_item(id, data)
			_update_filters()
	)
	
	# set up collection
	for id: MineralIndex.IdIndex in GameManager.minerals_unlocked:
		add_item(id, GameManager.mineral_data[id])
	
	# set up group select
	_group_select.clear()
	var group_name: String = ""
	for value: int in Constants.MineralGroup.values():
		if (value == 0):
			group_name = "ALL"
		else:
			group_name = Constants.MineralGroup.find_key(value)
		_group_select.add_item(group_name.capitalize(), value)
	
	# update display by filter
	_update_filters()


## Add mineral data to display collection[br]
## return false if already exist, otherwise true
func add_item(id: int, data: DataContainerMineral) -> void:
	# already exists
	if (_items.has(id)):
		return
	
	# add item_frame node
	var _item_frame: ItemFrame = ITEMFRAME.instantiate() as ItemFrame
	_item_frame.setup(id, data)
	_item_frame.visible = false
	_item_frame.name = str(id)
	_grid_container.add_child(_item_frame)
	
	# save reference
	_items.set(id, _item_frame)
	
	# sort to correct order
	var children: Array[Node] = _grid_container.get_children()
	children.erase(_item_frame)
	
	for child: Node in children:
		if _item_frame.name.naturalnocasecmp_to(child.name) == -1:
			_grid_container.move_child(_item_frame, child.get_index())
			break


## Apply filters and update display
func _update_filters() -> void:
	var searchEnabled: bool = not _search.text.is_empty()
	var groupEnabled: bool = not _group_select.selected == 0
	
	# handle visibility of each item frame and the count label
	_count = 0
	var search_text: String = _search.text.to_lower()
	for item: ItemFrame in _items.values():
		var displayed: bool = true
		
		# check search input
		if (searchEnabled):
			if (not search_text in item.mineral_name.text.to_lower()
			and not search_text in item.mineral_id.text):
				displayed = false
		
		# check group select
		if (groupEnabled):
			if (not _group_select.selected == item.mineral_group):
				displayed = false
		
		_count += 1 if displayed else 0
		item.visible = displayed
	
	_updateCountLabel()


## Search input signal - text changed
func _search_input_text_changed(_new_text: String) -> void:
	_update_filters()


## Filter select signal - item selected
func _filter_select_item_selected(_index: int) -> void:
	_update_filters()


## Update the count label
func _updateCountLabel() -> void:
	_count_label.text = "Showing" + " " + str(_count) + " " + "Minerals"


## Toggle visibility
func _toggle_visibility() -> void:
	visible = not visible


## Hide window
func _on_close_button_pressed() -> void:
	visible = false
