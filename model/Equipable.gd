extends Object
class_name Equipable

var name = ""
var bonusHealth = 0
var bonusAttack = 0
var bonusMana = 0

func _init(n: String, health: float, attack: float, mana: float):
	self.name = n
	self.bonusHealth = health
	self.bonusAttack = attack
	self.bonusMana = mana
