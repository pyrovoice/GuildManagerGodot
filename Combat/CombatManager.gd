extends Resource
class_name CombatManager

var displayedCombat: Combat = null

static var instance: CombatManager = null;
static func getInstance() -> CombatManager:
	if(CombatManager.instance == null):
		CombatManager.instance = CombatManager.new()
	return CombatManager.instance

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
