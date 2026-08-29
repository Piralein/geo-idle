# Refactor after GameJam
 - Rewrite the DataContainer with a base class and a generic interface so it can be used without having to repeat everything in the GameData
 - Remove Constants class and implement it in the respecitive classes
 - Better naming convention for classes
 - Split GameManager into submodules, so its not a superclass
 - maybe some code consistency lol?
 - enums as type definitions are displayed incorrectly by the inspector, use int
 - replace "not" in if with "!", its just silly...
