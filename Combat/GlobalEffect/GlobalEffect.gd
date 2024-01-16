extends Object
class_name GlobalEffect

var applyCondition = EffectApplyCondition.ALL
var baseValue = 0
var scaling = {}
func doesEffectApply(skill, source, targets, effect: EffectDescriptor):
	return true

func getTotalValue(skill, source, targets, effect):
	var total = baseValue
	for s in scaling:
		pass
	return total

func applyGlobalEffect(skill, source, targets, effect: EffectDescriptor ):
	if !doesEffectApply(skill, source, targets, effect):
		return
