extends Resource
class_name SkillLogicStrategy

@export var skill: Skill
@export var effectToSkillLogicTargetingDic: Dictionary#< EffectDescriptor, SkillLogicTargeting>
@export var activationConditions: Array[SkillLogicCondition]

static func create(_skill, _effectToSkillLogicTargetingDic: Dictionary, _activationConditions:Array[SkillLogicCondition] = []):
	var inst = SkillLogicStrategy.new()
	inst.skill = _skill
	inst.effectToSkillLogicTargetingDic = _effectToSkillLogicTargetingDic
	inst.activationConditions = _activationConditions
	return inst

func canActivate(c: CombatantInFight) -> bool:
	for condition in activationConditions:
		if !condition.canActivateSkill(c, skill):
			return false
	return true
