extends SkillLogicCondition
class_name SkillLogicConditionTargetLife

var comparison = ">"
var isPercent = false
var value = 0

func _init():
	self.stringValue = "Target Health"
	
func getAdditionalRequirement() -> Array:
	var additionalRequirement: Array = []
	additionalRequirement.push_back(SkillLogicConditionHelper.getGenericComparisonOptionButton(comparison))
	var spinner = SkillLogicConditionHelper.getGenericSpinbox(value)
	additionalRequirement.push_back(SkillLogicConditionHelper.getGenericPercentOrValueButton(isPercent, spinner))
	additionalRequirement.push_back(spinner)
	return additionalRequirement
	
func filterTargetsForConditions(c: CombatantInFight, s: Skill, targets: Array[CombatantInFight]) -> Array[CombatantInFight]:
	return targets.filter(func(t):
		var targetLife = t.healthCurrent
		var targetValue = value if !isPercent else t.getAttribute(CombatAttributeEnum.att.HEALTH)*value/100
		match comparison:
			">": return targetLife > targetValue
			"=": return targetLife == targetValue
			"<": return targetLife < targetValue
		)
