extends Object

class_name EffectDescriptor

var baseValue: float = 0
var scalings := {}
var effectType = EffectDecriptorType.DAMAGE
var additionalEffect = null
var outsideMultipliers = 0

func getTotalValue(source: CombatantInFight) -> float:
	var total = baseValue
	for effectScalings in scalings.keys():
		if source.attributes.find_key(effectScalings) != null:
			total += source.attributes[effectScalings]
	return total
