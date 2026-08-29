class_name MineralIndex
extends RefCounted
## Static class containing mineral base definitions
##
## IMA approved mineral, listed by [url]https://www.mindat.org/[/url]
## Custom Resources have to many problems
## just hardcode the data into a dictionary

## Id index[br]
## Corrolates with the mindat.org index
enum IdIndex {
	UNIDENTIFIED = 0,
	ALBITE = 96,
	NATIVE_ALUMINIUM = 107,
	ANORTHITE = 246,
	NATIVE_ANTIMONY = 262,
	NATIVE_ARSENIC = 357,
	NATIVE_COPPER = 1209,
	FLUORITE = 1576,
	NATIVE_GOLD = 1720,
	MACEDONITE = 2507,
	MICROCLINE = 2704,
	ORTHOCLASE = 3026,
	QUARTZ = 3337,
	SANIDINE = 3521,
}

## Data index[br]
## Contains a list of all minerals in the game
## with their defined data[br][br]
## Hardness is the avarage of the min/max rounded[br]
## Specific Gravity is the avarage of the min/max rounded
const DataIndex: Dictionary[int, Dictionary] = {
	# part of the feldspar group - one of the most common
	IdIndex.ALBITE: {
		"name": "Albite",
		"group": Constants.MineralGroup.SILICATES,
		"crystal_system": Constants.CrystalSystem.TRICLINIC,
		"icon": "uid://c6wb01fnyiqn3",
		"hardness": 6,
		"specific_gravity": 3,
		"prospect_rate": 285,
	},
	IdIndex.NATIVE_ALUMINIUM: {
		"name": "Native Aluminium",
		"group": Constants.MineralGroup.ELEMENTS,
		"crystal_system": Constants.CrystalSystem.CUBIC,
		"icon": "uid://c5ohitotki7cn",
		"hardness": 3,
		"specific_gravity": 3,
		"prospect_rate": 255,
	},
	# part of the feldspar group - one of the most common
	IdIndex.ANORTHITE: {
		"name": "Anorthite",
		"group": Constants.MineralGroup.SILICATES,
		"crystal_system": Constants.CrystalSystem.TRICLINIC,
		"icon": "uid://bvolgj102icx3",
		"hardness": 6,
		"specific_gravity": 3,
		"prospect_rate": 285,
	},
	IdIndex.NATIVE_ANTIMONY: {
		"name": "Native Antimony",
		"group": Constants.MineralGroup.ELEMENTS,
		"crystal_system": Constants.CrystalSystem.TRIGONAL,
		"icon": "uid://b18x8ab6gegra",
		"hardness": 3,
		"specific_gravity": 7,
		"prospect_rate": 215,
	},
	IdIndex.NATIVE_ARSENIC: {
		"name": "Native Arsenic",
		"group": Constants.MineralGroup.ELEMENTS,
		"crystal_system": Constants.CrystalSystem.TRIGONAL,
		"icon": "uid://cal0g42kafob3",
		"hardness": 4,
		"specific_gravity": 6,
		"prospect_rate": 235,
	},
	IdIndex.NATIVE_COPPER: {
		"name": "Native Copper",
		"group": Constants.MineralGroup.ELEMENTS,
		"crystal_system": Constants.CrystalSystem.CUBIC,
		"icon": "uid://b0al5ncdsbp4l",
		"hardness": 3,
		"specific_gravity": 9,
		"prospect_rate": 195,
	},
	# starter mineral
	IdIndex.FLUORITE: {
		"name": "Fluorite",
		"group": Constants.MineralGroup.HALIDES,
		"crystal_system": Constants.CrystalSystem.CUBIC,
		"icon": "uid://f6box5747tnn",
		"hardness": 4,
		"specific_gravity": 3,
		"prospect_rate": 265,
	},
	IdIndex.NATIVE_GOLD: {
		"name": "Native Gold",
		"group": Constants.MineralGroup.ELEMENTS,
		"crystal_system": Constants.CrystalSystem.CUBIC,
		"icon": "uid://c6cvbsts7ivsv",
		"hardness": 3,
		"specific_gravity": 17,
		"prospect_rate": 115,
	},
	IdIndex.MACEDONITE: {
		"name": "Macedonite",
		"group": Constants.MineralGroup.OXIDES,
		"crystal_system": Constants.CrystalSystem.TETRAGONAL,
		"icon": "uid://bdb8hfoittes7",
		"hardness": 6,
		"specific_gravity": 8,
		"prospect_rate": 235,
	},
	# part of the k-feldspar group - one of the most common
	IdIndex.MICROCLINE: {
		"name": "Microcline",
		"group": Constants.MineralGroup.SILICATES,
		"crystal_system": Constants.CrystalSystem.TRICLINIC,
		"icon": "uid://dni7eihfp1cpy",
		"hardness": 6,
		"specific_gravity": 3,
		"prospect_rate": 285,
	},
	# part of the k-feldspar group - one of the most common
	IdIndex.ORTHOCLASE: {
		"name": "Orthoclase",
		"group": Constants.MineralGroup.SILICATES,
		"crystal_system": Constants.CrystalSystem.MONOCLINIC,
		"icon": "uid://cla6tvsxbj4wx",
		"hardness": 6,
		"specific_gravity": 3,
		"prospect_rate": 285,
	},
	# one of the most common
	IdIndex.QUARTZ: {
		"name": "Quartz",
		"group": Constants.MineralGroup.OXIDES,
		"crystal_system": Constants.CrystalSystem.TRIGONAL,
		"icon": "uid://sjs7tcod0417",
		"hardness": 7,
		"specific_gravity": 3,
		"prospect_rate": 295,
	},
	# part of the k-feldspar group - one of the most common
	IdIndex.SANIDINE: {
		"name": "Sanidine",
		"group": Constants.MineralGroup.SILICATES,
		"crystal_system": Constants.CrystalSystem.MONOCLINIC,
		"icon": "uid://b46aqxmarym53",
		"hardness": 6,
		"specific_gravity": 3,
		"prospect_rate": 285,
	},
}
