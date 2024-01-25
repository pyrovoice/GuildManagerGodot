extends Object
class_name Equipable

var name = ""
var attributes: Dictionary = {}

func _init(n: String, health: float, attack: float, mana: float):
	self.name = n
	self.attributes[CombatAttribute.att.HEALTH] = health
	self.attributes[CombatAttribute.att.MANA] = mana
	self.attributes[CombatAttribute.att.STRENGTH] = attack
