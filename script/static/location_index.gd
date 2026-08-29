class_name LocationIndex
extends RefCounted
## Static class containing location base definitions
##
## Custom Resources have to many problems
## just hardcode the data into a dictionary

## Id index[br]
## Pokemon contains: "Route X", "City", "Town", "Island"
enum IdIndex {
	UNIDENTIFIED = 0,
	ROUTE_1 = 1,
	ROUTE_2 = 2,
	ROUTE_3 = 3,
	ROUTE_4 = 4,
	GRANITE_CITY = 5000, # Big city, like Saffron city
	DIORITE_TOWN = 5001, # Starter town, like pallet town
}

## Data index[br]
## Contains a list of all locations in the game
## with their defined data
const DataIndex: Dictionary[int, Dictionary] = {
	IdIndex.ROUTE_1: {
		"name": "Route 1",
		"type": Constants.LocationType.BATTLE_ZONE,
		"minerals": [
			MineralIndex.IdIndex.ALBITE,
			MineralIndex.IdIndex.ANORTHITE,
		],
		"background": "uid://dsr78osvbdpv3",
	},
	IdIndex.ROUTE_2: {
		"name": "Route 2",
		"type": Constants.LocationType.BATTLE_ZONE,
		"minerals": [
			MineralIndex.IdIndex.ALBITE,
			MineralIndex.IdIndex.ANORTHITE,
			MineralIndex.IdIndex.NATIVE_ALUMINIUM,
		],
		"background": "uid://dsr78osvbdpv3",
	},
	IdIndex.ROUTE_3: {
		"name": "Route 3",
		"type": Constants.LocationType.BATTLE_ZONE,
		"minerals": [
			MineralIndex.IdIndex.ALBITE,
			MineralIndex.IdIndex.MICROCLINE,
			MineralIndex.IdIndex.ORTHOCLASE,
			MineralIndex.IdIndex.SANIDINE,
			MineralIndex.IdIndex.QUARTZ,
			MineralIndex.IdIndex.NATIVE_ARSENIC,
		],
		"background": "uid://dsr78osvbdpv3",
	},
	IdIndex.ROUTE_4: {
		"name": "Route 4",
		"type": Constants.LocationType.BATTLE_ZONE,
		"minerals": [
			MineralIndex.IdIndex.ANORTHITE,
			MineralIndex.IdIndex.ORTHOCLASE,
			MineralIndex.IdIndex.SANIDINE,
			MineralIndex.IdIndex.MACEDONITE,
			MineralIndex.IdIndex.QUARTZ,
			MineralIndex.IdIndex.NATIVE_ANTIMONY,
			MineralIndex.IdIndex.NATIVE_COPPER,
		],
		"background": "uid://dsr78osvbdpv3",
	},
	IdIndex.GRANITE_CITY: {
		"name": "Granite City",
		"type": Constants.LocationType.LANDMARK,
		"background": "uid://b8crdlrgk3y0a",
		"npc_ids": [],
	},
	IdIndex.DIORITE_TOWN: {
		"name": "Diorite Town",
		"type": Constants.LocationType.LANDMARK,
		"background": "uid://b8crdlrgk3y0a",
		"npc_ids": [
			NpcIndex.IdIndex.PROFESSOR_CRUST,
		],
	},
}
