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
var position: Vector2 = Vector2(0, 0)
var statusEffects: Array[StatusEffect] = []

signal combatantEffectTriggers

func _init(c: Combatant):
	combatantBased = c
	reset()

func reset():
	name = combatantBased.name
	self.attributes = combatantBased.attributes
	delayToAct = combatantBased.delayToAct
	skills = combatantBased.skills
	if "equippableEquipped" in combatantBased:
		equippableEquipped = combatantBased.equippableEquipped.duplicate(true)
		for e in equippableEquipped:
			for attributeBonusType in e.attributes.keys():
				var newValue = self.attributes[attributeBonusType]
				if newValue == null: 
					newValue = 0
				newValue += e.attributes[attributeBonusType]
				self.attributes[attributeBonusType] = newValue
	healthCurrent = getAttribute(CombatAttributeEnum.att.HEALTH)
	manaCurrent = getAttribute(CombatAttributeEnum.att.MANA)
	actionCooldown = 0

func update(delta):
	if self.isAlive():
		self.actionCooldown += getActualSpeed()*delta
		for statusEffect in self.statusEffects:
			statusEffect.update(delta)
	if name == "Hero":
		var poise = skills.filter(func(s): return s.name == "Poise strike")
		if poise.size() == 1:
			var p: Skill = poise[0]

func getActualSpeed():
	var speed = 1
	for s in statusEffects:
		speed = s.getSpeedMultiplier()*speed
	return speed

func receiveDamage(damage: float):
	self.healthCurrent = clamp(self.healthCurrent - damage, 0, self.getAttribute(CombatAttributeEnum.att.HEALTH))
	self.receiveStatusEffect(StatusEffectPoise.new(damage))

func receiveStatusEffect(status: StatusEffect):
	var s = self.statusEffects.filter(func(s): return s.name == status.name)
	if s.size() == 1:
		s[0].accumulateStatus(status)
		print("Accumulated " + status.name)
	else:
		status.onApply(self)
		status.trigger.connect(func(): emitStatusEffectTrigger(status))
		print("Applied " + status.name)

func emitStatusEffectTrigger(status):
	combatantEffectTriggers.emit(status)
	
func receiveHealing(healValue: float, canResurect: bool = false):
	if isAlive() or canResurect:
		self.healthCurrent = clamp(self.healthCurrent + healValue, 0, self.getAttribute(CombatAttributeEnum.att.HEALTH))
		
func canActivateSkill(skillStrategy: SkillLogicStrategy):
	if self.skills.find(skillStrategy.skill) == -1:
		return false
	return canPaySkillCost(skillStrategy.skill) && skillStrategy.canActivate(self)

#TODO
func canPaySkillCost(skill: Skill):
	return true

func canAct():
	return isAlive() && actionCooldown >= delayToAct

func isAlive():
	return self.healthCurrent > 0
	
func getAttribute(attribute: CombatAttributeEnum.att) -> float:
	if attributes.keys().find(attribute) == -1:
		return 0
	return attributes[attribute]

func getAttributeCurrentValue(attribute: CombatAttributeEnum.att) -> float:
	match attribute:
		CombatAttributeEnum.att.HEALTH:
			return healthCurrent
		CombatAttributeEnum.att.MANA:
			return manaCurrent
		_:
			return getAttribute(attribute)

func setPosition(newPosition: Vector2):
	self.position = newPosition
	
func removeStatusEffect(status: StatusEffect):
	self.statusEffects.erase(status)

func receiveInterupt():
	self.actionCooldown = 0
