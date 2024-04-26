extends Resource
class_name CombatantInFight

@export var combatantBased: Combatant

@export var name: String = "default name"
@export var attributes: Dictionary = {}
@export var healthCurrent: float
@export var manaCurrent: float
@export var actionCooldown: float = 0
@export var delayToAct: float = 4
@export var skills: Array[Skill] = []
@export var equippableEquipped: Array[Equipable] = []
@export var position: Vector2 = Vector2(0, 0)

static func create(c: Combatant):
	var cc = CombatantInFight.new()
	cc.combatantBased = c
	cc.reset()
	return cc

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
	return canPaySkillCost(skillStrategy.skill) && skillStrategy.canActivate(self)

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
	
