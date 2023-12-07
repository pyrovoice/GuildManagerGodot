extends Object
class_name SkillFactory

static func getSkillBasicAttack() -> Skill:
	var skill = Skill.new()
	skill.isActive = true
	skill.name = "Basic Attack"
	var effect1 = EffectDescriptor.new()
	skill.skillParts.push_back(effect1)
	return skill
	
static func getSkillBasicHeal() -> Skill:
	return null
	
static func getSkillLifesteal() -> Skill:
	return null
	
static func getSkillPoison() -> Skill:
	return null
	
static func getSkillSummonBasic() -> Skill:
	return null
