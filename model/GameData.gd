extends Object
class_name GameData

static var instance: GameData = null

static func getInstance() -> GameData:
	if instance == null:
		instance = GameData.new()
	return instance

var opponents: Array[Opponent] = []
var locations: Array[FightingLocation] = []
func _init():
	loadData()
	
func loadData():
	opponents.push_back(Opponent.new("Rat", 25, 0, 5))
	opponents.push_back(Opponent.new("Rat King", 150, 0, 20))
	var l = FightingLocation.new("Tutorial")
	l.possibleOpponents["Rat"] = 1
	l.encounterPerLevel = 3
	l.averageEncounterDifficulty = 3
	l.difficultyVariance = 1
	l.bossEncounter = ["Rat King", "Rat", "Rat", "Rat", "Rat", "Rat"]
	locations.push_back(l)

func getOpponent(name) -> Opponent:
	var found = opponents.filter(func(o): return o.name == name)
	if found.size() > 0:
		return found[0]
	return null
