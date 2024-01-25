extends Object
class_name StatusEffect # Base class for all status effects

var name = ""
var delayToTrigger = -1
var currentDelay = 0
var value = -1

signal trigger

func _init(_name: String, _delayToTrigger: float = -1, _value: float = -1):
	name = _name
	delayToTrigger = _delayToTrigger
	value = _value
	
func update(delta):
	currentDelay += delta
	if currentDelay >= delayToTrigger:
		self.onTrigger()

func onTrigger():
	trigger.emit()
	
#Called by combat when trigger is emitted
func resolveTrigger(combatantHolder: CombatantInFight, combat: Combat):
	pass
