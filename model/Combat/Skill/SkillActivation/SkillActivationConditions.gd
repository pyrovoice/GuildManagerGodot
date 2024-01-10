class_name SkillActivationConditions
enum SkillActivationConditionsType{
	MANA,
	LIFE,
	CAN_USE_FULL_EFFECT
}

enum SkillActivationConditionsComparator{
	LESS_THAN, MORE_THAN, EQUAL_TO
}

enum SkillActivationConditionsValueType{
	PERCENT, FLAT
}

enum Check{
	SELF, TARGET
}

var combatantToCheckCondition: Check
var skillActivationConditions: SkillActivationConditionsType
var skillActivationConditionsComparator: SkillActivationConditionsComparator
var value = 0
var skillActivationConditionsValueType: SkillActivationConditionsValueType
