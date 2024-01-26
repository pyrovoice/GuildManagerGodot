extends Control

@onready var attribute = $attribute
@onready var value = $value

func init(_attribute: CombatAttributeEnum.att, _value: float):
	attribute.text = CombatAttributeEnum.getString(_attribute)
	value = str(_value)
