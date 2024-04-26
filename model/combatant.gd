extends Resource
class_name Combatant

@export var name: String = "default name"
@export var delayToAct: float = 2.5
@export var skills: Array[Skill] = []
@export var attributes: Dictionary = {}
@export var combatantStrategy: CombatantStrategy

func _init(_name: String = "", _health:float = 100, _mana: float = 100, _strength: float = 10):
	self.name = _name
	self.attributes[CombatAttributeEnum.att.HEALTH] = _health
	self.attributes[CombatAttributeEnum.att.MANA] = _mana
	self.attributes[CombatAttributeEnum.att.STRENGTH] = _strength
	skills.push_back(SkillFactory.getSkillChangeRow())
	skills.push_back(SkillFactory.getSkillBasicAttack())
	resetStrategyToDefault()

func resetStrategyToDefault():
	combatantStrategy = CombatantStrategy.new()
	for skill in skills:
		combatantStrategy.orderedSkillActivationStrategy.push_back(SkillFactory.getDefaultLogicForSkill(skill))
		
func getAttribute(attribute: CombatAttributeEnum):
	return attributes.find_key(attribute)
