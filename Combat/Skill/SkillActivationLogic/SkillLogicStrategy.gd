extends Object
class_name SkillLogicStrategy

var skill: Skill
var defaultTargetting: SkillLogicTargeting
var activationConditions: Array[SkillLogicCondition]

func _init(_skill, _defaultTargetting, _activationConditions:Array[SkillLogicCondition] = []):
	skill = _skill
	defaultTargetting = _defaultTargetting
	activationConditions = _activationConditions

func canActivate(c: CombatantInFight) -> bool:
	for condition in activationConditions:
		if !condition.canActivateSkill(c, skill):
			return false
			
	return true

func filterTargets(c: CombatantInFight, targets: Array[CombatantInFight]) -> Array[CombatantInFight]:
	for condition in activationConditions:
		targets = condition.filterTargetsForCondition(c, skill, targets)
	return targets
