extends Object
class_name GameMaster

static var instance: GameMaster = null
static func getInstance() -> GameMaster:
	if GameMaster.instance ==  null:
		GameMaster.instance = GameMaster.new()
	return GameMaster.instance


func process(_delta):
	CombatManager.getInstance().process(_delta)

func addRewardForCombat(_c: Combat):
	#TODO add Combat rewards
	PlayerData.getInstance().gold = PlayerData.getInstance().gold +4

func getAvailableCombatants() -> Array[Combatant]:
	return PlayerData.getInstance().combatants.filter((self.isCombatantAvailable))

func isCombatantAvailable(c: Combatant) -> bool:
	if c == null:
		return true
	if !PlayerData.getInstance().combatants.has(c):
		return false
	for combat in CombatManager.getInstance().combats:
		for cc in combat.combatantsPlayer:
			if cc.combatantBased == c:
				return false
	return true
