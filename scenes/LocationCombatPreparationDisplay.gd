extends Control
class_name LocationCombatPreparationDisplay

var location: FightingLocation
@onready var validate = $Validate
signal validated
const COMBATANT_INFO_DISPLAY_SMALL = preload("res://scenes/CombatantInfoDisplaySmall.tscn")
@onready var availableCombatantsGrid = $AvailableCombatants/GridContainer

func init(_location: FightingLocation):
	location = _location
	validate.pressed.connect(func(): validated.emit())
	var combatants = GameMaster.getInstance().getAvailableCombatants()
	for c in combatants:
		var cd = COMBATANT_INFO_DISPLAY_SMALL.instantiate()
		availableCombatantsGrid.add_child(cd)
		cd.init(c)

#TODO checker pourquoi pas de deplacement sur un drag and drop
