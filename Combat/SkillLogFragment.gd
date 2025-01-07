extends Resource
class_name SkillLogFragment

enum SLFType{
	DAMAGE_INFLICTED,
	HEAL,
	MOVE,
	MISSING
}

var type:SLFType = SLFType.MISSING
var value = 0
var effectSource: EffectDescriptor
var effectReceiver: CombatantInFight

func _init(_type, _value, _effectSource, receiver):
	type = _type
	value = _value
	effectSource = _effectSource
	effectReceiver = receiver
