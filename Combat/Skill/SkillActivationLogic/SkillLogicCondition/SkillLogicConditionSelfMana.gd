extends SkillLogicCondition
class_name SkillLogicConditionSelfMana

var comparison = ">"
var isPercent = false
var value = 0

func _init():
	self.stringValue = "Mana"
	
func getAdditionalRequirement() -> Array[Control]:
	var additionalRequirement: Array = []
	additionalRequirement.push_back(SkillLogicConditionHelper.getGenericComparisonOptionButton(comparison))
	var spinner = SkillLogicConditionHelper.getGenericSpinbox(value)
	additionalRequirement.push_back(SkillLogicConditionHelper.getGenericPercentOrValueButton(isPercent, spinner))
	additionalRequirement.push_back(spinner)
	return additionalRequirement
	
func canActivateSkill(c: CombatantInFight, s: Skill) -> bool:
	var combatantMana = c.manaCurrent
	var targetValue = value if !isPercent else c.getAttribute(CombatAttributeEnum.att.MANA)*value/100
	match comparison:
		">": return combatantMana > targetValue
		"=": return combatantMana == targetValue
		"<": return combatantMana < targetValue
	return false
