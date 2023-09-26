extends Node

var combatantsPlayer: Array[Node] = []
var combatantsOpponent: Array[Node] = []

func init():
	addCombatantToTeam(Combatant.new("Hero", 500, 100, 12), true)
	addCombatantToTeam(Combatant.new("Rat 1" ,25, 0, 5), false)
	addCombatantToTeam(Combatant.new("Rat 1" ,25, 0, 5), false)
	addCombatantToTeam(Combatant.new("Rat 1" ,25, 0, 5), false)
	addCombatantToTeam(Combatant.new("Rat King" ,100, 20, 20), false)

func addCombatantToTeam(c: Combatant, isAlly: bool):
	var cDisplay = preload("res://objects/combatant_display_combat.tscn").instantiate()
	self.find_child("GridContainer").add_child(cDisplay)
	cDisplay.init(c)
	if isAlly:
		combatantsPlayer.append(cDisplay)
	else:
		combatantsOpponent.append(cDisplay)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for combatant in self.combatantsPlayer:
		updateCombatant(combatant.c, delta)
	for combatant in self.combatantsOpponent:
		updateCombatant(combatant.c, delta)
	pass

func updateCombatant(combatant: Combatant, delta: float):
	combatant.timerSinceLastAction += delta
