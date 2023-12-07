extends GlobalEffect
class_name DamageMultiplierGlobalEffect

func applyGlobalEffect(skill, source, targets, effect: EffectDescriptor):
	super(skill, source, targets, effect)
	if effect.effectType != EffectDecriptorType.DAMAGE:
		return
	effect.outsideMultipliers += getTotalValue(skill, source, targets, effect)
