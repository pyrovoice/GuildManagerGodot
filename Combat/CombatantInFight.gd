extends Object
class_name CombatantInFight

var combatantBased: Combatant

var name: String = "default name"
var attributes: Dictionary = {}
var healthCurrent: float
var manaCurrent: float
var actionCooldown: float = 0
var delayToAct: float = 4
var skills: Array[Skill] = []
var equippableEquipped: Array[Equipable] = []
var statusEffects: Array[StatusEffect] = []

signal combatantEffectTriggers

func _init(c: Combatant):
	combatantBased = c
	name = c.name
	self.attributes = c.attributes
	self.healthCurrent = c.getAttribute(CombatAttribute.att.HEALTH)
	self.manaCurrent = c.getAttribute(CombatAttribute.att.MANA)
	delayToAct = c.delayToAct
	skills = c.skills
	if "equippableEquipped" in c:
		equippableEquipped = c.equippableEquipped.duplicate(true)
		for e in equippableEquipped:
			for attributeBonusType in e.attributes.keys():
				var newValue = self.attributes[attributeBonusType]
				if newValue == null: 
					newValue = 0
				newValue += e.attributes[attributeBonusType]
				self.attributes[attributeBonusType] = newValue
	statusEffects.append(StatusEffectBasicDot.new())
	for statusEffect in statusEffects:
		statusEffect.trigger.connect(func(): combatantEffectTriggers.emit(statusEffect))
	reset()

func receiveDamage(damage: float):
	self.healthCurrent = clamp(self.healthCurrent - damage, 0, self.combatantBased.getAttribute(CombatAttribute.att.HEALTH))

func receiveHealing(healValue: float, canResurect: bool = false):
	if isAlive() or canResurect:
		self.healthCurrent = clamp(self.healthCurrent + healValue, 0, self.combatantBased.getAttribute(CombatAttribute.att.HEALTH))
		
func update(delta):
	self.actionCooldown += delta
	for statusEffect in self.statusEffects:
		statusEffect.update(delta)

func canAct():
	return isAlive() && actionCooldown >= delayToAct

func triggerAction(currentCombat: Combat) -> ActivatedSkillData:
	self.actionCooldown = 0
	#TODO add skill selection depending on player's script
	#Select first skill that's activeable according to activation script
	for skill in self.skills:
		var conditions = SkillFactory.getDefaultSkillActivationDataForSkill(skill)
	var activatedSkill = ActivatedSkillData.new()
	activatedSkill.activator = self
	activatedSkill.skill = self.skills[0]
	activatedSkill.targets = getTargetsForSkill(activatedSkill, currentCombat)
	return null

func isAlive():
	return self.healthCurrent > 0

func reset():
	self.healthCurrent = self.combatantBased.getAttribute(CombatAttribute.att.HEALTH)
	self.actionCooldown = 0
	self.manaCurrent = self.combatantBased.getAttribute(CombatAttribute.att.MANA)
	
func getTargetsForSkill(activatedSkill: ActivatedSkillData, currentCombat: Combat) -> Array[CombatantInFight]:
	match activatedSkill.skill.skillParts[0].effectType:
		EffectDecriptorType.DAMAGE:
			return currentCombat.getRandomTargetablOpponent(self, activatedSkill.skill.requiredTargets)
		EffectDecriptorType.HEAL:
			return currentCombat.getRandomTargetablAlly(self, activatedSkill.skill.requiredTargets)
	return []
