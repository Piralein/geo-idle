class_name Constants
extends Object
## Static class containing constants

## Mineral Groups[br]
## based on Strunz-Mindat 20026 (Nickel-Strunz 9th Edition (2001))
enum MineralGroup {
	UNIDENTIFIED = 0,
	ELEMENTS = 1,
	SULFITES_SULFOSALTS,
	HALIDES,
	OXIDES,
	CARBONATES,
	BORATES,
	SULFATES,
	PHOSPHATES_ARSENATES_VANADATES,
	SILICATES,
	ORGANIC_COMPOUNDS,
}

## Crystal Systems[br]
## ╯‵□′)╯︵┻━┻
enum CrystalSystem {
	UNIDENTIFIED = 0,
	TRICLINIC = 1,
	MONOCLINIC,
	ORTHORHOMBIC,
	TETRAGONAL,
	TRIGONAL,
	HEXAGONAL,
	CUBIC, ## old name = Isometric
}

## Location meta types
enum LocationType {
	UNIDENTIFIED = 0, ## not defined
	BATTLE_ZONE = 1, ## contains encounters
	LANDMARK = 2, ## contains dialogs and utilities
}

## Battle meta types
enum BattleType {
	UNIDENTIFIED = 0, ## not defined
	WILD = 1, ## looping on current location
}

## Notification type
enum NotificationType {
	UNIDENTIFIED = 0,
	UNLOCK = 1,
}
