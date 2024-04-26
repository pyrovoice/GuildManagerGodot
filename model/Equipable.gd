extends Resource
class_name Equipable

@export var name = ""
@export var attributes: Dictionary = {}

static func create(n: String, health: float, attack: float, mana: float) -> Equipable:
	var c = Equipable.new()
	c.name = n
	c.attributes[CombatAttributeEnum.att.HEALTH] = health
	c.attributes[CombatAttributeEnum.att.MANA] = mana
	c.attributes[CombatAttributeEnum.att.STRENGTH] = attack
	return c
