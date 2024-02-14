extends Object
class_name PlayerData

static var instance: PlayerData = null
var gold = 50
var maxCombatantLevel = 10

var combatants: Array[Combatant] = []
var equipments: Array[Equipable] = [Equipable.new("Test Sword", 100, 10, 0), Equipable.new("Test Sword 2", 50, 10, 0)]
var unlockedLocation: Array[FightingLocation] = []

func _init():
	var c = Combatant.new("Hero", 80, 10, 5)
	c.skills[1] = SkillFactory.getSkillAttackAll()
	c.resetStrategyToDefault()
	self.combatants.push_back(c)
	self.combatants.push_back(Combatant.new("Hero2", 200, 20, 10))
	self.combatants.push_back(Combatant.new("Hero3", 300, 30, 15))
	self.combatants.push_back(Combatant.new("Hero4", 400, 40, 20))
	self.unlockedLocation.append_array(GameData.getInstance().locations)
	
static func getInstance() -> PlayerData:
	if PlayerData.instance == null:
		PlayerData.instance = PlayerData.new()
	return PlayerData.instance

func getEquippedTo(equipment: Equipable) -> Combatant:
	var hero = null
	for c in combatants:
		var found =  c.equippableEquipped.has(equipment)
		if found:
			hero = (c)
			break
	return hero

func equipToCombatant(equipment: Equipable, combatant: Combatant):
	var c = getEquippedTo(equipment)
	if c:
		c.equippableEquipped.erase(equipment)
	combatant.equippableEquipped.push_back(equipment)
	return true

func removeFromCombatant(equipment: Equipable, combatant: Combatant):
	combatant.equippableEquipped.erase(equipment)
	return true
