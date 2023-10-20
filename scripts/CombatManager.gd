extends Object
class_name CombatManager

var combats: Array[Combat] = []
var displayedCombat: Combat = null

static var instance: CombatManager = null;
static func getInstance():
	if(CombatManager.instance == null):
		CombatManager.instance = CombatManager.new()
	return CombatManager.instance
	
signal combatListUpdated

func _init():
	addCombat()
	addCombat()
	pass # Replace with function body.

func addCombat():
	var c = Combat.new()
	c.init()
	combats.push_back(c)
	self.combatListUpdated.emit()

func process(_delta):
	for c in combats:
		c.process(_delta)
		if c.isCombatOver():
			resolveCombat(c)
	pass

func resolveCombat(combat: Combat):
	print("Resolve combat " + combat.name)
	GameMaster.getInstance().addRewardForCombat(combat)
	combat.resetCombatants()
	
