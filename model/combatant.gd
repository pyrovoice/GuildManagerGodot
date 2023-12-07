extends Object

class_name Combatant

var name: String = "default name"
var delayToAct: float = 4
var skills: Array[Skill] = []
var attributes: Dictionary = {}

func _init(_name: String, _health:float = 100, _mana: float = 100, _strength: float = 10):
	self.name = _name
	self.attributes[CombatAttribute.HEALTH] = _health
	self.attributes[CombatAttribute.MANA] = _mana
	self.attributes[CombatAttribute.STRENGTH] = _strength
	skills.push_back(SkillFactory.getSkillBasicAttack())
