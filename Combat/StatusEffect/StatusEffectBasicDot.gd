extends StatusEffect
class_name StatusEffectBasicDot

func _init():
	super("Basic Dot", 3, 5)

func resolveTrigger(combat: Combat):
	super(combat)
	currentDelay = 0
	holder.receiveDamage(self.value)
	self.value = self.value * 0.9
	if self.value < 1:
		self.onDurationReachZero()
