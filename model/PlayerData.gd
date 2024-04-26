extends Resource
class_name PlayerData

static var instance: PlayerData = null
@export var gold: int = 50
@export var maxCombatantLevel: int

@export var combatants: Array[Combatant] = []
@export var equipments: Array[Equipable]  = []
@export var unlockedLocation: Array[FightingLocation]  = []
@export var combats: Array[Combat] = []

func _init():
	var c = Combatant.new("Hero", 80, 10, 5)
	c.skills[1] = SkillFactory.getSkillAttackAll()
	c.resetStrategyToDefault()
	self.combatants.push_back(c)
	self.combatants.push_back(Combatant.new("Hero2", 200, 20, 10))
	self.combatants.push_back(Combatant.new("Hero3", 300, 30, 15))
	self.combatants.push_back(Combatant.new("Hero4", 400, 40, 20))
	self.unlockedLocation.append_array(GameData.getInstance().locations)
	self.gold = 50
	self.maxCombatantLevel = 10
	
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
