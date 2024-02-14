extends Object
class_name ActivatedSkillData

var activator: CombatantInFight
var skill: Skill
var effectToTargetsDic: Dictionary #<EffectDescriptor, Array[CombatantInFight]>

func _init(_activator: CombatantInFight, _skill: Skill, _effectToTargetsDic: Dictionary):
	self.activator = _activator
	self.skill = _skill
	self.effectToTargetsDic = _effectToTargetsDic

func getLog() -> String:
	var s = activator.name + " activates " + skill.name + " targeting:"
	var effectCounter = 0
	for effect: EffectDescriptor in effectToTargetsDic:
		s += "effect " + str(effectCounter) + " "
		for target in effectToTargetsDic[effect]:
			s += target.name + " "
	return s
