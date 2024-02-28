extends SkillLogicCondition
class_name SkillLogicConditionSelfPosition

var isFrontRow:CombatPositionsCombatant.ROW = CombatPositionsCombatant.ROW.FRONT_ROW

func _init():
	self.stringValue = "Value"
	
func getAdditionalRequirement() -> Array[Control]:
	var additionalRequirement: Array[Control] = []
	additionalRequirement.push_back(SkillLogicConditionHelper.getGenericPositionDropdown(isFrontRow))
	return additionalRequirement
	
func canActivateSkill(c: CombatantInFight, s: Skill) -> bool:
	return c.position.y == isFrontRow
