class_name NpcIndex
extends RefCounted
## Static class containing npc base definitions
##
## Custom Resources have to many problems
## just hardcode the data into a dictionary

## Id index
enum IdIndex {
	UNIDENTIFIED = 0,
	PROFESSOR_CRUST = 1,
}

## Data index[br]
## Contains a list of all npc's in the game
## with their defined data
const DataIndex: Dictionary[int, Dictionary] = {
	IdIndex.PROFESSOR_CRUST: {
		"name": "Prof. Crust",
		"icon": "",
		"unlock_required": false,
		"dialog": {
			0: "Welcome to Diorite Town![br][br]Please head over to route 1 and mine 10 minerals for me." + 
			"[br]Take this [color=#eebf80]Fluorite[/color] to get started.",
			1: "Wonderful! Wonderful![br][br]Come back to me after you " +
			"[s color=red]defeated the elite four[/s] collection all available minerals in the region",
			2: "What do you mean only 12?[br]Seems like the developer was spending more time thinking" +
			" about a code refactor, than adding more content... the files even contain more mineral icons!",
		},
	},
}
