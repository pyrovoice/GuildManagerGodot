extends Resource
class_name SaveData

const PATH = "user://"
const pathPlayerData = "playerData.res"
const pathCombatData = "combatData.res"

static func createSave():
	var instance: PlayerData = PlayerData.getInstance()
	var rVal = ResourceSaver.save(PlayerData.getInstance(), PATH+pathPlayerData)
	
static func loadGame():
	var playerDataLoaded: PlayerData = ResourceLoader.load(PATH+pathPlayerData)
	if playerDataLoaded:
		PlayerData.instance = playerDataLoaded
		var inst = PlayerData.instance
	else:
		print("Player data not found")
