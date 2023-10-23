extends Object
class_name GameMaster

static var instance: GameMaster = null
static func getInstance() -> GameMaster:
	if GameMaster.instance ==  null:
		GameMaster.instance = GameMaster.new()
	return GameMaster.instance


func process(_delta):
	CombatManager.getInstance().process(_delta)

func addRewardForCombat(c: Combat):
	PlayerData.getInstance().gold = PlayerData.getInstance().gold +1

func getAvailableCombatants() -> Array[Combatant]:
	return PlayerData.getInstance().combatants.filter((self.isCombatantAvailable))

func isCombatantAvailable(c: Combatant) -> bool:
	if !PlayerData.getInstance().combatants.has(c):
		return false
	for combat in CombatManager.getInstance().combats:
		if combat.combatantsPlayer.has(c):
			return false
	return true
