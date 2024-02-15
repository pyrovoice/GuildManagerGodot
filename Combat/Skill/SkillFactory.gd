extends Object
class_name SkillFactory

static func getSkillBasicAttack() -> Skill:
	var skill = Skill.new("Basic Attack", true)
	var effect1 = EffectDescriptor.new()
	effect1.scalings[CombatAttributeEnum.att.STRENGTH] = 1
	effect1.requiredTargets = 1
	effect1.targetType = SkillTargetEnum.t.ANY
	skill.skillParts.push_back(effect1)
	return skill
	
static func getSkillAttackAll() -> Skill:
	var skill = Skill.new("Attack All", true)
	var effect1 = EffectDescriptor.new()
	effect1.scalings[CombatAttributeEnum.att.STRENGTH] = 1
	effect1.requiredTargets = 0
	effect1.optionalTargets = 99
	effect1.targetType = SkillTargetEnum.t.ALL_OPPONENTS
	skill.skillParts.push_back(effect1)
	return skill
	
static func getSkillBasicHeal() -> Skill:
	var skill = Skill.new("Basic Heal", true)
	var effect1 = EffectDescriptor.new()
	effect1.scalings[CombatAttributeEnum.att.POWER] = 1
	effect1.requiredTargets = 1
	effect1.targetType = SkillTargetEnum.t.ANY
	skill.skillParts.push_back(effect1)
	return skill
	
static func getSkillChangeRow() -> Skill:
	var skill = Skill.new("Move", true)
	var effect1 = EffectDescriptor.new()
	effect1.effectType = EffectDecriptorType.DISPLACE
	effect1.requiredTargets = 1
	effect1.targetType = SkillTargetEnum.t.SELF
	skill.skillParts.push_back(effect1)
	return skill
	
static func getSkillHitEnnemyAndHealAlly() -> Skill:
	var skill = Skill.new("Move", true)
	skill.range = 2
	var effect1 = EffectDescriptor.new()
	effect1.scalings[CombatAttributeEnum.att.STRENGTH] = 1
	effect1.requiredTargets.push_back(SkillTargetEnum.t.ANY)
	skill.skillParts.push_back(effect1)
	var effect2 = EffectDescriptor.new()
	effect2.scalings[CombatAttributeEnum.att.POWER] = 1
	effect2.requiredTargets.push_back(SkillTargetEnum.t.ANY)
	skill.skillParts.push_back(effect2)
	return skill
	
static func getSkillLifesteal() -> Skill:
	return null
	
static func getSkillPoison() -> Skill:
	return null

static func getDefaultTargetingForSkill(s: Skill) -> Dictionary:
	var effectToSkillLogicTargetingDic = {}
	for e in s.skillParts:
		var skillLogicStrategy: SkillLogicTargeting = SkillLogicTargeting.new()
		skillLogicStrategy.preferredTargets = getDefaultTargetingForEffect(e)
		effectToSkillLogicTargetingDic[e] = skillLogicStrategy
	return effectToSkillLogicTargetingDic
	
static func getDefaultTargetingForEffect(s: EffectDescriptor):
	if !SkillTargetEnum.skillTargetRequiresTarget(s.targetType):
		return SkillActivationOptimalTargets.e.NONE
	match s.effectType:
		EffectDecriptorType.DAMAGE, EffectDecriptorType.STATUS_EFFECT:
			return SkillActivationOptimalTargets.e.OPPONENT_LOWEST_HEALTH
		EffectDecriptorType.HEAL:
			return SkillActivationOptimalTargets.e.ALLY_LEAST_HEALTH
	return SkillActivationOptimalTargets.e.NONE
	
static func getPossibleConditionsForSkill(skill: Skill) -> Array[SkillLogicCondition]:
	return [SkillLogicConditionSelfAttribute.new(), SkillLogicConditionTargetLife.new()]
	
static func getDefaultLogicForSkill(skill: Skill) -> SkillLogicStrategy:
	var skillLogicStrategy = SkillLogicStrategy.new(skill,getDefaultTargetingForSkill(skill))
	if skill.name == "Move":
		var moveIfHealthUnder50percent = SkillLogicConditionSelfAttribute.new()
		moveIfHealthUnder50percent.attribute = CombatAttributeEnum.att.HEALTH
		moveIfHealthUnder50percent.comparison = "<"
		moveIfHealthUnder50percent.isPercent = true
		moveIfHealthUnder50percent.value = 50
		skillLogicStrategy.activationConditions.push_back(moveIfHealthUnder50percent)
		var moveIfFrontRow = SkillLogicConditionSelfPosition.new()
		
		skillLogicStrategy.activationConditions.push_back(moveIfFrontRow)
	return skillLogicStrategy
	
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
