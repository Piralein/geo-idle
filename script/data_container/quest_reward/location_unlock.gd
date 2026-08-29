class_name QuestRewardLocationUnlock
extends QuestReward
## quest reward for location unlock
##
## unlocks a location

## id of the location to unlock
var _location_id: LocationIndex.IdIndex = LocationIndex.IdIndex.UNIDENTIFIED


## init reward
func _init(location_id: LocationIndex.IdIndex) -> void:
	_location_id = location_id


## get location unlock
func get_reward() -> void:
	GameManager.unlock_location(_location_id)
