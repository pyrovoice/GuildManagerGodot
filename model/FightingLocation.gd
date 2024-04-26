extends Resource
class_name FightingLocation

@export var name = ""
#How many encounter there are per level to reach the boss
@export var encounterPerLevel = 10
#Opponents that can be encounter and their relative difficulty for this dungeon
@export var possibleOpponents = {}
@export var averageEncounterDifficulty = 10
@export var difficultyVariance = 5
# The encounter the player gets on the last floor of each level
@export var bossEncounter = []

static func create(n: String):
	var fl: FightingLocation = FightingLocation.new()
	fl.name = n
	return fl
