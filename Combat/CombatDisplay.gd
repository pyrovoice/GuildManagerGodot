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
	for y in combat.combatants.getNumberRowLocation():
		for x in combat.combatants.getSlotPerRowLocation():
			addCombatantOrEmptySlot(Vector2(x, y), true)
			addCombatantOrEmptySlot(Vector2(x, y), false)
	
func addCombatantOrEmptySlot(combatantLocation: Vector2, isAlly: bool):
	var display = ColorRect.new()
	var arrayToLookAt = combat.combatants.getTeam(isAlly)
	var combatants = arrayToLookAt.values()
	var combatantIndex = arrayToLookAt.values().find(combatantLocation)
	if combatantIndex != -1:
		display = COMBATANT_DISPLAY_COMBAT.instantiate()
		display.init(arrayToLookAt.keys()[combatantIndex])
	display.set_custom_minimum_size(Vector2(100, 100))
	var container
	if isAlly:
		container = allies_front if combatantLocation.y == combat.combatants.FRONT_ROW else allies_back
	else:
		container = ennemies_front if combatantLocation.y == combat.combatants.FRONT_ROW else ennemies_back
	container.add_child(display)

func _on_delete_combat_pressed():
	removeCombat.emit()
