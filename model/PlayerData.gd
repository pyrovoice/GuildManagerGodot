extends Object
class_name PlayerData

static var instance: PlayerData = null
var gold = 50
var maxCombatantLevel = 10

var combatants: Array[Combatant] = []
var unlockedLocation: Array[String] = []

func _init():
	self.combatants.push_back(Combatant.new("Hero", 100, 10, 5))
	self.combatants.push_back(Combatant.new("Hero2", 200, 20, 10))
	self.combatants.push_back(Combatant.new("Hero3", 300, 30, 15))
	self.combatants.push_back(Combatant.new("Hero4", 400, 40, 20))
	self.unlockedLocation.push_back("Location 1")
	self.unlockedLocation.push_back("Location 2")
	self.unlockedLocation.push_back("Location 3")
	self.unlockedLocation.push_back("Location 4")
	
static func getInstance() -> PlayerData:
	if PlayerData.instance == null:
		PlayerData.instance = PlayerData.new()
	return PlayerData.instance

