extends Control

var combat: Combat = null
func init(co :Combat):
	if co:
		self.combat = co
		combat.combatantsChange.connect(func(): updateCombatants())
		updateCombatants()

func updateCombatants():
	self.get_node("LocationName").text = combat.location.name + " " + str(combat.level) + " - " + str(combat.encounterCounter) + "/" + str(combat.location.encounterPerLevel)
	for c in get_node("ContainerAllies").get_children():
		get_node("ContainerAllies").remove_child(c)
	for c in get_node("ContainerEnnemies").get_children():
		get_node("ContainerEnnemies").remove_child(c)
	for c in combat.combatantsPlayer:
		addCombatantToTeam(c, true)
	for c in combat.combatantsOpponent:
		addCombatantToTeam(c, false)
			
			
func addCombatantToTeam(c: CombatantInFight, isAlly: bool):
	var cDisplay = preload("res://scenes/combatant_display_combat.tscn").instantiate()
	if isAlly:
		self.get_node("ContainerAllies").add_child(cDisplay)
	else:
		self.get_node("ContainerEnnemies").add_child(cDisplay)
	cDisplay.init(c)
