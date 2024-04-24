extends Resource
class_name SaveData

const PATH = "user://"
const pathPlayerData = "playerData.res"
const pathCombatData = "combatData.res"

static func createSave():
	var instance: PlayerData = PlayerData.getInstance()
	var rVal = ResourceSaver.save(PlayerData.getInstance(), PATH+pathPlayerData)
	print(rVal)
	
static func loadGame():
	var playerDataLoaded: PlayerData = ResourceLoader.load(PATH+pathPlayerData, "PlayerData").duplicate(true)
	if playerDataLoaded:
		PlayerData.instance = playerDataLoaded
	else:
		print("Player data not found")
