extends Object
class_name SkillLogicCondition

var stringValue = ""

func getAdditionalRequirement() -> Array[Control]:
	return []
	
func getStringValue() -> String:
	return self.stringValue

#Implement in children
func canActivateSkill(c: CombatantInFight, s: Skill) -> bool:
	return true
	
func filterTargetsForCondition(c: CombatantInFight, s: Skill, targets: Array[CombatantInFight]) -> Array[CombatantInFight]:
	return targets

