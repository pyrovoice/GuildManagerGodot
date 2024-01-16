extends Object
class_name Skill

enum SkillTargetModeEnum {
	SELF, OTHER_ALLY, ANY_ALLY, OPPONENT, ANY, NONE
}
var name: String = ""
var isActive: bool = false
var requiredTargets: int = 0
var skillParts: Array[EffectDescriptor] = []

func _init(_name, _isActive, _requiredTargets):
	self.name = _name
	self.isActive = _isActive
	self.requiredTargets = _requiredTargets
