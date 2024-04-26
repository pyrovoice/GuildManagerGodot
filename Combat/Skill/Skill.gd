extends Resource
class_name Skill

@export var name: String = ""
@export var isActive: bool = false
@export var skillParts: Array[EffectDescriptor] = []

func _init(_name = "", _isActive = false):
	self.name = _name
	self.isActive = _isActive
