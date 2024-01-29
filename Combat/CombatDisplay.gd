extends Control

@onready var delete_combat = $DeleteCombat
@onready var location_name = $LocationName
@onready var ennemies_front = $Ennemies/VBoxContainer/EnnemiesFront
@onready var ennemies_back = $Ennemies/VBoxContainer/EnnemiesBack
@onready var allies_front = $Allies/VBoxContainer/AlliesFront
@onready var allies_back = $Allies/VBoxContainer/AlliesBack


const COMBATANT_DISPLAY_COMBAT = preload("uid://ccfjcmib782th")
signal removeCombat

var combat: Combat = null
func init(co :Combat):
	if co:
		self.combat = co
		combat.combatantsChange.connect(updateCombatants)
		updateCombatants()

func updateCombatants():
	location_name.text = combat.location.name + " " + str(combat.level) + " - " + str(combat.encounterCounter) + "/" + str(combat.location.encounterPerLevel)
	for c in ennemies_front.get_children():
		ennemies_front.remove_child(c)
	for c in ennemies_back.get_children():
		ennemies_back.remove_child(c)
	for c in allies_front.get_children():
		allies_front.remove_child(c)
	for c in allies_back.get_children():
		allies_back.remove_child(c)
	addCombatantsToTeam(combat.combatantsPlayerSpaces[0], allies_front)
	addCombatantsToTeam(combat.combatantsPlayerSpaces[1], allies_back)
	addCombatantsToTeam(combat.combatantsOpponentSpaces[0], ennemies_front)
	addCombatantsToTeam(combat.combatantsOpponentSpaces[1], ennemies_back)
	
func addCombatantsToTeam(combatantArrayWithNulls, container):
	for i in range(0, combatantArrayWithNulls.size()):
		var display = ColorRect.new()
		if combatantArrayWithNulls[i]:
			display = COMBATANT_DISPLAY_COMBAT.instantiate()
			display.init(combatantArrayWithNulls[i])
		display.set_custom_minimum_size(Vector2(100, 100))
		container.add_child(display)

func _on_delete_combat_pressed():
	removeCombat.emit()
