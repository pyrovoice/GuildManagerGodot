extends Object
class_name GameMaster

static var instance: GameMaster = null
static func getInstance():
	if GameMaster.instance ==  null:
		GameMaster.instance = GameMaster.new()
	return GameMaster.instance


func process(_delta):
	CombatManager.getInstance().process(_delta)

func addRewardForCombat(c: Combat):
	PlayerData.getInstance().gold = PlayerData.getInstance().gold +1
