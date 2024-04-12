extends Object
class_name StatusEffect # Base class for all status effects

var holder: CombatantInFight = null
var name = ""
const minValue = 0
const maxValue = 100

var delayToTrigger = -1
var currentDelay = -1
var value = -1
var duration = -1
signal trigger

func _init(_name: String, _delayToTrigger: float = -1, _value: float = -1, _duration = -1):
	name = _name
	delayToTrigger = _delayToTrigger
	value = _value
	duration = _duration

func onApply(_holder: CombatantInFight):
	self.holder = _holder
	self.holder.statusEffects.push_back(self)
	self.value = clamp(self.value, minValue, maxValue)

func update(delta):
	if delayToTrigger != -1:
		currentDelay += delta
		if currentDelay >= delayToTrigger:
			self.onTrigger()
	if duration != -1:
		self.duration -= delta
		if duration <= 0:
			self.onDurationReachZero()

func onTrigger():
	trigger.emit()
	
#Called by combat when trigger is emitted
func resolveTrigger(combat: Combat):
	pass
	
func getSpeedMultiplier():
	return 1

func onDurationReachZero():
	holder.removeStatusEffect(self)

func accumulateStatus(status: StatusEffect):
	if self.duration != -1:
		self.duration += status.duration
	if self.value != -1:
		self.value += status.value

func getText():
	return self.value
