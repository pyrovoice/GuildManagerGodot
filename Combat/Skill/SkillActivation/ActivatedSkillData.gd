extends Object
class_name ActivatedSkillData

var activator: CombatantInFight
var skill: Skill
var targets: Array[CombatantInFight]

func _init(_activator: CombatantInFight, _skill: Skill, _targets: Array[CombatantInFight] = []):
	self.activator = _activator
	self.skill = _skill
	self.targets = _targets
