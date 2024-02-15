extends Object
class_name SkillLogicStrategy

var skill: Skill
var effectToSkillLogicTargetingDic: Dictionary#< EffectDescriptor, SkillLogicTargeting>
var activationConditions: Array[SkillLogicCondition]

func _init(_skill, _effectToSkillLogicTargetingDic: Dictionary, _activationConditions:Array[SkillLogicCondition] = []):
	skill = _skill
	effectToSkillLogicTargetingDic = _effectToSkillLogicTargetingDic
	activationConditions = _activationConditions

func canActivate(c: CombatantInFight) -> bool:
	for condition in activationConditions:
		if !condition.canActivateSkill(c, skill):
			return false
	return true
