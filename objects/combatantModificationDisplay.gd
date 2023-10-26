extends Control

var combatantToModify: Combatant = null
var equipables: Array[Equipable]

func _ready():
	if combatantToModify == null:
		self.combatantToModify = PlayerData.getInstance().combatants[0]
	self.equipables = PlayerData.getInstance().equipments
	refreshDisplay()

func setCombatant(c:Combatant):
	combatantToModify = c
	refreshDisplay()
		
func refreshDisplay():
	for n in get_node("AvailableEquipables").get_children():
		get_node("AvailableEquipables").remove_child(n)
	for n in get_node("HeroEquipmentSlots").get_children():
		get_node("HeroEquipmentSlots").remove_child(n)
	for e in self.equipables:
		var equippedC = PlayerData.getInstance().getEquippedTo(e)
		if equippedC == combatantToModify:
			continue
		addAvailableEquipmentDisplay(e, equippedC)
	for e in combatantToModify.equippableEquipped:
		var button: Button = getButton(e, combatantToModify)
		button.pressed.connect(func(): self.removeFromCombatant(e))
		get_node("HeroEquipmentSlots").add_child(button)

func addAvailableEquipmentDisplay(equipment: Equipable, equippedCombatant: Combatant):
	var button: Button = getButton(equipment, equippedCombatant)
	button.pressed.connect(func(): self.equipToCombatant(equipment))
	get_node("AvailableEquipables").add_child(button)

func getButton(equipment: Equipable, equippedCombatant: Combatant):
	var displayText = equipment.name
	if equippedCombatant != null:
		displayText = displayText + "("+equippedCombatant.name+")"
	displayText += "\nHealth: " + str(equipment.bonusHealth) + "\nAttack: " + str(equipment.bonusAttack)
	var button: Button = Button.new()
	button.text = displayText
	return button
	
func equipToCombatant(equipment: Equipable):
	var success = PlayerData.getInstance().equipToCombatant(equipment, combatantToModify)
	refreshDisplay()

func removeFromCombatant(equipment: Equipable):
	var success = PlayerData.getInstance().removeFromCombatant(equipment, combatantToModify)
	refreshDisplay()
