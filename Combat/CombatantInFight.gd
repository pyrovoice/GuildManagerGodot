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
	
func receiveDamage(damage: float):
	self.healthCurrent = clamp(self.healthCurrent - damage, 0, self.getAttribute(CombatAttributeEnum.att.HEALTH))

func receiveHealing(healValue: float, canResurect: bool = false):
	if isAlive() or canResurect:
		self.healthCurrent = clamp(self.healthCurrent + healValue, 0, self.getAttribute(CombatAttributeEnum.att.HEALTH))
		
func canActivateSkill(skillStrategy: SkillLogicStrategy):
	if self.skills.find(skillStrategy.skill) == -1:
		return false
	return canPaySkillCost(skillStrategy.skill) && skillStrategy.canActivate(self, )

#TODO
func canPaySkillCost(skill: Skill):
	return true

func update(delta):
	if self.isAlive():
		self.actionCooldown += delta

func canAct():
	return isAlive() && actionCooldown >= delayToAct

func isAlive():
	return self.healthCurrent > 0



func getAttribute(attribute: CombatAttributeEnum.att):
	if attributes.keys().find(attribute) == -1:
		return 0
	return attributes[attribute]
