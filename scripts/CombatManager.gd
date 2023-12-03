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
	pass # Replace with function body.


func addCombat(location: FightingLocation, combatants: Array[Combatant]) -> Combat:
	for c in combatants:
		if !GameMaster.getInstance().isCombatantAvailable(c):
			return null
	var c = Combat.new()
	c.init(combatants, location)
	combats.push_back(c)
	return c
	
func stopCombat(combat:Combat):
	self.combats.erase(combat)
		
func process(_delta):
	for c in combats:
		c.process(_delta)
	pass
