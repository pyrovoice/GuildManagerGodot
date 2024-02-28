extends Object
class_name CombatManager

var combats: Array[Combat] = []
var displayedCombat: Combat = null

static var instance: CombatManager = null;
static func getInstance() -> CombatManager:
	if(CombatManager.instance == null):
		CombatManager.instance = CombatManager.new()
	return CombatManager.instance

func _init():
	pass


func addCombat(location: FightingLocation, frontRow: Array[Combatant], backRow: Array[Combatant]) -> Combat:
	for c in frontRow:
		if !GameMaster.getInstance().isCombatantAvailable(c):
			return null
	for c in backRow:
		if !GameMaster.getInstance().isCombatantAvailable(c):
			return null
	var c = Combat.new()
	c.init(frontRow, backRow, location)
	combats.push_back(c)
	return c
	
func stopCombat(combat:Combat):
	self.combats.erase(combat)
		
func process(_delta):
	for c in combats:
		c.process(_delta)
	pass
