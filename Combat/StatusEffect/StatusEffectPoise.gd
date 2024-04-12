extends StatusEffect
class_name StatusEffectPoise

func _init(value: float = 0):
	super("Poise", -1, value)

func update(delta):
	if value >= maxValue:
		self.onTrigger()
	else:
		self.value = clamp(self.value-delta, 0, 100)
		if self.value <= 0:
			self.onDurationReachZero()

func resolveTrigger(combat: Combat):
	super(combat)
	var stunEffect = StatusEffectStunned.new(5)
	holder.receiveStatusEffect(stunEffect)
	holder.statusEffects.erase(self)
	
