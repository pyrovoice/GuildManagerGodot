extends Control

@onready var delete_combat = $DeleteCombat
@onready var ennemies_container = $MarginContainer/EnnemiesContainer
@onready var allies_container = $MarginContainer2/AlliesContainer
@onready var location_name = $LocationName

const COMBATANT_DISPLAY_COMBAT = preload("res://scenes/combatant_display_combat.tscn")
signal removeCombat

var combat: Combat = null
func init(co :Combat):
	if co:
		self.combat = co
		combat.combatantsChange.connect(updateCombatants)
		updateCombatants()

func updateCombatants():
	location_name.text = combat.location.name + " " + str(combat.level) + " - " + str(combat.encounterCounter) + "/" + str(combat.location.encounterPerLevel)
	for c in ennemies_container.get_children():
		ennemies_container.remove_child(c)
	for c in allies_container.get_children():
		allies_container.remove_child(c)
	for c in combat.getCombatants(true):
		addCombatantToTeam(c, true)
	for c in combat.getCombatants(false):
		addCombatantToTeam(c, false)
			
			#TODO: Afficher les placements dans le combat
func addCombatantToTeam(c: CombatantInFight, isAlly: bool):
	var cDisplay = COMBATANT_DISPLAY_COMBAT.instantiate()
	if isAlly:
		allies_container.add_child(cDisplay)
	else:
		ennemies_container.add_child(cDisplay)
	cDisplay.init(c)


func _on_delete_combat_pressed():
	removeCombat.emit()
