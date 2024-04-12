extends StatusEffect
class_name StatusEffectStunned

func _init(value: float = 0):
	super("Stunned", -1, -1, value)

func getSpeedMultiplier():
	return 0

func onApply(value):
	super(value)
	holder.receiveInterupt()

func getText():
	return self.duration
