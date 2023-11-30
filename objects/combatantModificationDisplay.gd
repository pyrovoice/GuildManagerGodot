extends Control

var combatantToModify: Combatant = null
var equipables: Array[Equipable]

func _ready():
	if combatantToModify == null:
		self.combatantToModify = PlayerData.getInstance().combatants[0]
	self.equipables = PlayerData.getInstance().equipments

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
		var button: DraggeableEquipment = getButton(e, combatantToModify)
		get_node("HeroEquipmentSlots").add_child(button)
		button.onClick.connect(func(): removeFromCombatant(button.equipment))
	var emptySlots = combatantToModify.equipmentSlots - combatantToModify.equippableEquipped.size()
	for i in emptySlots:
		var cr: ColorRect = ColorRect.new()
		var square = Vector2.ZERO
		square.x = (self.get_node("HeroEquipmentSlots") as GridContainer).get_size().y
		square.y = (self.get_node("HeroEquipmentSlots") as GridContainer).get_size().y
		cr.set_custom_minimum_size(square)
		get_node("HeroEquipmentSlots").add_child(cr)
			

func addAvailableEquipmentDisplay(equipment: Equipable, equippedCombatant: Combatant):
	var label: DraggeableEquipment = getButton(equipment, equippedCombatant)
	get_node("AvailableEquipables").add_child(label)
	label.onClick.connect(func(): equipToCombatant(label.equipment))

func getButton(equipment: Equipable, equippedCombatant: Combatant) -> DraggeableEquipment:
	var displayText = equipment.name
	if equippedCombatant != null:
		displayText = displayText + "("+equippedCombatant.name+")"
	displayText += "\nHealth: " + str(equipment.bonusHealth) + "\nAttack: " + str(equipment.bonusAttack)
	var square: DraggeableEquipment = preload("res://objects/DraggableEquipment.tscn").instantiate()
	square.init(equipment)
	square.set_custom_minimum_size(Vector2(150, 150))
	return square
	
func equipToCombatant(equipment: Equipable):
	PlayerData.getInstance().equipToCombatant(equipment, combatantToModify)
	refreshDisplay()

func removeFromCombatant(equipment: Equipable):
	PlayerData.getInstance().removeFromCombatant(equipment, combatantToModify)
	refreshDisplay()
