extends Object

class_name Combatant

var name: String = ""
var healthMax: float
var healthCurrent: float
var manaCurrent: float
var manaMax: float
var attack: float
var timerSinceLastAction: float = 0
var timerToAct: float = 10000


func _init(name: String="default name", health:float = 100, mana: float = 100, attack: float = 10):
	self.name = name
	self.healthMax = health
	self.healthCurrent = health
	self.manaMax = mana
	self.manaCurrent = mana
	self.attack = attack
	
	
func receiveDamage(damage: float):
	self.healthCurrent = clamp(self.healthCurrent - damage, 0, self.healthMax)

func update(delta):
	self.timerSinceLastAction += delta
