extends Resource
class_name SaveData

const PATH = "user://"
const pathPlayerData = "playerData.res"
const pathCombatData = "combatData.res"

static func createSave():
	ResourceSaver.save(PlayerData.getInstance(), PATH+pathPlayerData)
	ResourceSaver.save(CombatManager.getInstance(), PATH+pathCombatData)
	#SavesHelper.save_game()
	
	
static func loadGame():
	var playerDataLoaded = ResourceLoader.load(PATH+pathPlayerData, "", ResourceLoader.CACHE_MODE_IGNORE)
	if playerDataLoaded:
		PlayerData.instance = playerDataLoaded
	else:
		print("Player data not found")
	var combatDataLoaded = ResourceLoader.load(PATH+pathCombatData, "", ResourceLoader.CACHE_MODE_IGNORE)
	if combatDataLoaded:
		CombatManager.instance = combatDataLoaded
	else:
		print("Combat data not found")
	#SavesHelper.loadGame()

static func resetGame():
	PlayerData.instance = null
	CombatManager.instance = null
