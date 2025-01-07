extends Resource
class_name Combatant

@export var name: String = "default name"
@export var delayToAct: float = 2.5
@export var skills: Array[Skill] = []
@export var attributes: Dictionary = {}
@export var combatantStrategy: CombatantStrategy
@export var equippableEquipped: Array[Equipable] = []

static func create(_name: String = "", _health:float = 100, _mana: float = 100, _strength: float = 10):
	var instance = Combatant.new()
	instance.name = _name
	instance.attributes[CombatAttributeEnum.att.HEALTH] = _health
	instance.attributes[CombatAttributeEnum.att.MANA] = _mana
	instance.attributes[CombatAttributeEnum.att.STRENGTH] = _strength
	instance.skills.push_back(SkillFactory.getSkillChangeRow())
	instance.skills.push_back(SkillFactory.getSkillBasicAttack())
	instance.resetStrategyToDefault()
	return instance

func resetStrategyToDefault():
	combatantStrategy = CombatantStrategy.new()
	for skill in skills:
		combatantStrategy.orderedSkillActivationStrategy.push_back(SkillFactory.getDefaultLogicForSkill(skill))
		
func getAttribute(attribute: CombatAttributeEnum):
	return attributes.find_key(attribute)
