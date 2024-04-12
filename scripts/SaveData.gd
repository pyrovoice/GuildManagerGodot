extends Resource
class_name SaveData

const PATH = "user://save.res"
var playerData
var combatData

static func createSave():
	var instance = SaveData.new()
	instance.playerData = PlayerData.getInstance()
	instance.combatData = CombatManager.getInstance()
	var rVal = ResourceSaver.save(instance, PATH)
	print(rVal)
	
static func loadGame():
	var save = ResourceLoader.load(PATH)
	if save:
		PlayerData.instance = save.playerData
		CombatManager.instance = save.combatData
		print("Save loaded")
	else:
		print("save not found")
