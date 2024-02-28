extends Object
class_name Skill

var name: String = ""
var isActive: bool = false
var skillParts: Array[EffectDescriptor] = []

func _init(_name, _isActive):
	self.name = _name
	self.isActive = _isActive
