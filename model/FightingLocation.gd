extends Object
class_name FightingLocation

var name = ""
#How many encounter there are per level to reach the boss
var encounterPerLevel = 10
#Opponents that can be encounter and their relative difficulty for this dungeon
var possibleOpponents = {}
var averageEncounterDifficulty = 10
var difficultyVariance = 5
# The encounter the player gets on the last floor of each level
var bossEncounter = []

func _init(n: String):
	self.name = n
