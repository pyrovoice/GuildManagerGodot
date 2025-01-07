extends Resource
class_name CombatManager

static var instance = null
static func getInstance():
	if instance == null:
		instance = CombatManager.new()
	return instance
	
var displayedCombat: Combat = null

func addCombat(location: FightingLocation, frontRow: Array[Combatant], backRow: Array[Combatant]) -> Combat:
	for c in frontRow:
		if !GameMaster.getInstance().isCombatantAvailable(c):
			return null
	for c in backRow:
		if !GameMaster.getInstance().isCombatantAvailable(c):
			return null
	var c = Combat.create(frontRow, backRow, location)
	PlayerData.getInstance().combats.push_back(c)
	return c
	
func stopCombat(combat:Combat):
	PlayerData.getInstance().combats.erase(combat)
		
func process(_delta):
	for c in PlayerData.getInstance().combats:
		c.process(_delta)
	pass
