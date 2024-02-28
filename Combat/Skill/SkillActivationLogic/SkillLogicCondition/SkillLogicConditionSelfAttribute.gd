extends SkillLogicCondition
class_name SkillLogicConditionSelfAttribute

var attribute: CombatAttributeEnum.att
var comparison = ">"
var isPercent = false
var value = 0

func _init():
	self.stringValue = "Value"
	
func getAdditionalRequirement() -> Array[Control]:
	var additionalRequirement: Array[Control] = []
	additionalRequirement.push_back(SkillLogicConditionHelper.getGenericAttributeDropdown(attribute))
	additionalRequirement.push_back(SkillLogicConditionHelper.getGenericComparisonOptionButton(comparison))
	var spinner = SkillLogicConditionHelper.getGenericSpinbox(value)
	additionalRequirement.push_back(SkillLogicConditionHelper.getGenericPercentOrValueButton(isPercent, spinner))
	additionalRequirement.push_back(spinner)
	return additionalRequirement
	
func canActivateSkill(c: CombatantInFight, s: Skill) -> bool:
	var combatantAttribute = c.getAttribute(attribute)
	var targetValue = value if !isPercent else c.getAttribute(attribute)*value/100
	match comparison:
		">": return c.getAttributeCurrentValue(attribute) > targetValue
		"=": return c.getAttributeCurrentValue(attribute) == targetValue
		"<": return c.getAttributeCurrentValue(attribute) < targetValue
	return false
