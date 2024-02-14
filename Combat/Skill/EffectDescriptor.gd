extends Object
class_name EffectDescriptor

var baseValue: float = 0
var scalings := {}
var effectType = EffectDecriptorType.DAMAGE
var additionalEffect = null
var outsideMultipliers = 0
var targetType: SkillTargetEnum.t = SkillTargetEnum.t.ANY
var requiredTargets: int = 0
var optionalTargets: int = 0
var range: int = 1 # 1-3, how many rows the skill can target. 1 is row in front (so if in the back, cannot aim at opponents)
