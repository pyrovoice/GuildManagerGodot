extends Control
class_name LocationCombatPreparationDisplay

var location: FightingLocation
@onready var validate = $Validate
signal validated
const COMBATANT_INFO_DISPLAY_SMALL = preload("res://scenes/CombatantInfoDisplaySmall.tscn")
@onready var availableCombatantsGrid = $AvailableCombatants/GridContainer
@onready var frontRowContainer = $MarginContainer/VSplitContainer/FrontRowContainer
@onready var backRowContainer = $MarginContainer/VSplitContainer/BackRowContainer
const COMBAT_PREPARATION_COMBATANT_SLOT = preload("res://scenes/CombatPreparationCombatantSlot.tscn")

func init(_location: FightingLocation):
	for child in availableCombatantsGrid.get_children():
		child.queue_free()
	for child in frontRowContainer.get_children():
		if child is Label:
			continue
		child.queue_free()
	for child in backRowContainer.get_children():
		if child is Label:
			continue
		child.queue_free()
	for i in range(0, 5):
		addSlotToRow(backRowContainer)
		addSlotToRow(frontRowContainer)
	location = _location
	validate.pressed.connect(func(): 
		print("Pressed")
		validated.emit())
	var combatants = GameMaster.getInstance().getAvailableCombatants()
	for c in combatants:
		var cd = COMBATANT_INFO_DISPLAY_SMALL.instantiate()
		availableCombatantsGrid.add_child(cd)
		cd.init(c)
		cd.onClicked.connect(func(event: InputEventMouseButton):
			if event.button_index == MOUSE_BUTTON_RIGHT && event.is_pressed():
				moveCombatantSlot(cd)
			)

func moveCombatantSlot(cd: CombatantInfoDisplaySmall):
	if cd == null:
		return
	if cd.get_parent() == availableCombatantsGrid:
		for child in frontRowContainer.get_children():
			if child.get_child_count() == 0 && child is CombatPreparationCombatantSlot:
				moveToCombatSlot(cd, child)
				return
		for child in backRowContainer.get_children():
			if child.get_child_count() == 0 && child is CombatPreparationCombatantSlot:
				moveToCombatSlot(cd, child)
				return
	else:
		removeFromCombatSlot(cd)
	
func addSlotToRow(row):
	var a = COMBAT_PREPARATION_COMBATANT_SLOT.instantiate()
	row.add_child(a)
	a.onDrop.connect(func(data): 
		moveToCombatSlot(data, a)
		)

func moveToCombatSlot(d: CombatantInfoDisplaySmall, slot):
	d.get_parent().remove_child(d)
	slot.add_child(d)
	d.position = Vector2(0,0)
	
func removeFromCombatSlot(d: CombatantInfoDisplaySmall):
	d.get_parent().remove_child(d)
	availableCombatantsGrid.add_child(d)

func getSelectedFrontRow() -> Array[Combatant]:
	return getSelectedRow(frontRowContainer, 5)

func getSelectedBackRow() -> Array[Combatant]:
	return getSelectedRow(backRowContainer, 5)

func getSelectedRow(container, size: int) -> Array[Combatant]:
	var selectRow: Array[Combatant] = []
	selectRow.resize(size)
	for slot in container.get_children():
		if slot.get_child_count() != 0:
			selectRow[slot.get_index()-1] = (slot.get_child(0) as CombatantInfoDisplaySmall).combatant
	return selectRow
