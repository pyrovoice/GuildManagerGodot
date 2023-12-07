extends Object
class_name SkillFactory

static func getSkillBasicAttack() -> Skill:
	var skill = Skill.new()
	skill.isActive = true
	skill.name = "Basic Attack"
	var effect1 = EffectDescriptor.new()
	effect1.scalings[CombatAttribute.STRENGTH] = 1
	skill.skillParts.push_back(effect1)
	return skill
	
static func getSkillBasicHeal() -> Skill:
	var skill = Skill.new()
	skill.isActive = true
	skill.name = "Basic Heal"
	var effect1 = EffectDescriptor.new()
	effect1.scalings[CombatAttribute.POWER] = 1
	skill.skillParts.push_back(effect1)
	return skill
	
static func getSkillLifesteal() -> Skill:
	return null
	
static func getSkillPoison() -> Skill:
	return null
"""
ACTIVE TODO:
static func getSkillSummonBasic() -> Skill
static func getSkillHealPoison
static func getSkillHealAnyStatus
static func getSkillAddRandomCombatAbility
status func getSkillCreateFireballProjectile
static func getSkillDamagePerStatusEffectOnTarget
charging skill (spend time, can be interupted, consume ressource over time, effect depending on the time spent)

PASSIVE TODO:
receiveStatus effect instead of damage when hit
Boosts N status effect
immune
immune from basic attacks
immune from non-equipped combatants
boost next action efficiency based on how long since the last action

"""
