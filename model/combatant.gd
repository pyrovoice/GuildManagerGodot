extends Object

class_name Combatant

var name: String = "default name"
var health: float
var mana: float
var strength: float
var delayToAct: float = 4
var skills: Array[Skill] = []

func _init(_name: String, _health:float = 100, _mana: float = 100, _strength: float = 10):
	self.name = _name
	self.health = _health
	self.mana = _mana
	self.strength = _strength
	skills.push_back(SkillFactory.getSkillBasicAttack())
	
	
