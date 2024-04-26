extends Resource
class_name EffectDescriptor

@export var baseValue: float = 0
@export var scalings := {}
@export var effectType: EffectDecriptorType.e = EffectDecriptorType.e.DAMAGE
@export var additionalEffect: EffectDescriptorAdditionalEffect.e = EffectDescriptorAdditionalEffect.e.NONE
@export var outsideMultipliers = 0
@export var targetType: SkillTargetEnum.t = SkillTargetEnum.t.ANY
@export var requiredTargets: int = 0
@export var optionalTargets: int = 0
@export var range: int = 1 # 1-3, how many rows the skill can target. 1 is row in front (so if in the back, cannot aim at opponents)
