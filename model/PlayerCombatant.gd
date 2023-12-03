extends Combatant
class_name PlayerCombatant

var equipmentSlots: int = 2
var equippableEquipped:Array[Equipable] = []

func _init(_name: String, _health:float = 100, _mana: float = 100, _strength: float = 10):
	super(_name, _health, _mana, _strength)
