extends Object
class_name SkillFactory

static func getSkillBasicAttack() -> Skill:
	var skill = Skill.new("Basic Attack", true, 1)
	var effect1 = EffectDescriptor.new()
	effect1.scalings[CombatAttribute.STRENGTH] = 1
	skill.skillParts.push_back(effect1)
	return skill
	
static func getSkillBasicHeal() -> Skill:
	var skill = Skill.new("Basic Heal", true, 1)
	var effect1 = EffectDescriptor.new()
	effect1.scalings[CombatAttribute.POWER] = 1
	skill.skillParts.push_back(effect1)
	return skill
	
static func getSkillLifesteal() -> Skill:
	return null
	
static func getSkillPoison() -> Skill:
	return null
	
static func getDefaultSkillActivationDataForSkill(s: Skill) -> SkillActivationParameter:
	var parameters = SkillActivationParameter.new()
	match s.skillParts[0].effectType:
		EffectDecriptorType.DAMAGE:
			parameters.skillActivationOptimalTargets = SkillActivationOptimalTargets.OPPONENT_LOWEST_HEALTH
	match s.skillParts[0].effectType:
		EffectDecriptorType.HEAL:
			parameters.skillActivationOptimalTargets.ALLY_LEAST_HEALTH
			var condition: SkillActivationConditions = SkillActivationConditions.new()
			condition.skillActivationConditions = SkillActivationConditions.SkillActivationConditionsType.CAN_USE_FULL_EFFECT
	return parameters

static func getPossibleConditionsForSkill(skill: Skill) -> Array[String]:
	return ["Mana", "Can Fully heal"]
	
static func getAdditionalParametersForConditions(condition: String) -> Array[Array]:
	match condition:
		"Mana":
			return [["<", "=", ">"], ["0", "100"], ["%", "n"]]
		"Can Fully heal":
			return []
	return []
	
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
resist all elements except N
resist all elements except N, changing every 5s

"""
