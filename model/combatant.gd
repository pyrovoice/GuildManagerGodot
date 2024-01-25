extends Object

class_name Combatant

var name: String = "default name"
var delayToAct: float = 4
var skills: Array[Skill] = []
var attributes: Dictionary = {}
var combatantStrategy: CombatantStrategy = CombatantStrategy.new()

func _init(_name: String, _health:float = 100, _mana: float = 100, _strength: float = 10):
	self.name = _name
	self.attributes[CombatAttributeEnum.att.HEALTH] = _health
	self.attributes[CombatAttributeEnum.att.MANA] = _mana
	self.attributes[CombatAttributeEnum.att.STRENGTH] = _strength
	skills.push_back(SkillFactory.getSkillBasicAttack())
	combatantStrategy.orderedSkillActivationStrategy.push_back(SkillFactory.getDefaultLogicForSkill(skills[0]))

func getAttribute(attribute: CombatAttributeEnum):
	return attributes.find_key(attribute)
