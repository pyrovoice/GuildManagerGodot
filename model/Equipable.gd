extends Object
class_name Equipable

var name = ""
var attributes: Dictionary = {}

func _init(n: String, health: float, attack: float, mana: float):
	self.name = n
	self.attributes[CombatAttributeEnum.att.HEALTH] = health
	self.attributes[CombatAttributeEnum.att.MANA] = mana
	self.attributes[CombatAttributeEnum.att.STRENGTH] = attack
