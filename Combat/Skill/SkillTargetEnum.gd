extends Object
class_name SkillTargetEnum

enum t{
	#Require no targeting
	SELF,
	ALL,
	OTHERS,
	ALL_OPPONENTS,
	ALL_ALLY,
	SAME_AS_PREVIOUS, #Use the same value as previosu effect
	
	#requires targeting
	ANY,
	ALLY,
	ALLY_OTHER,
	OPPONENT,
	TEST
}

static func skillTargetRequiresTarget(target: SkillTargetEnum.t) -> bool:
	match target:
		SkillTargetEnum.t.SELF, SkillTargetEnum.t.ALL, SkillTargetEnum.t.OTHERS, SkillTargetEnum.t.ALL_OPPONENTS, SkillTargetEnum.t.ALL_ALLY, SkillTargetEnum.t.SAME_AS_PREVIOUS:
			return false
		SkillTargetEnum.t.ANY, SkillTargetEnum.t.ALLY, SkillTargetEnum.t.ALLY_OTHER, SkillTargetEnum.t.OPPONENT, SkillTargetEnum.t.TEST:
			return true
	printerr("Skill target not implemented in SkillTargetEnum")
	return false
