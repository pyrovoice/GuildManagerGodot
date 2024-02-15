extends Object
class_name GameMaster

static var instance: GameMaster = null
static func getInstance() -> GameMaster:
	if GameMaster.instance ==  null:
		GameMaster.instance = GameMaster.new()
	return GameMaster.instance

func _init():
	SavesHelper.loadGame()
	
	
var lastS = 0
func process(_delta):
	if CombatManager.getInstance().combats.size() == 0:
		CombatManager.getInstance().addCombat(PlayerData.getInstance().unlockedLocation[0], \
	[PlayerData.getInstance().combatants[0]], \
	[])
	CombatManager.getInstance().process(_delta)
	if Time.get_datetime_dict_from_system()["second"] != lastS:
		SavesHelper.save_game()
		lastS = Time.get_datetime_dict_from_system()["second"]

func addRewardForCombat(_c: Combat):
	#TODO add Combat rewards
	PlayerData.getInstance().gold = PlayerData.getInstance().gold +4

func getAvailableCombatants() -> Array[Combatant]:
	return PlayerData.getInstance().combatants.filter((self.isCombatantAvailable))

func isCombatantAvailable(c: Combatant) -> bool:
	if c == null:
		return true
	var i = PlayerData.getInstance()
	if !PlayerData.getInstance().combatants.has(c):
		return false
	for combat in CombatManager.getInstance().combats:
		for cc in combat.combatantsPlayer:
			if cc.combatantBased == c:
				return false
	return true
