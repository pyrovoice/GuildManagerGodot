extends Resource
class_name Skill

@export var name: String = ""
@export var isActive: bool = false
@export var skillParts: Array[EffectDescriptor] = []

static func create(_name = "", _isActive = false):
	var inst = Skill.new()
	inst.name = _name
	inst.isActive = _isActive
	return inst
