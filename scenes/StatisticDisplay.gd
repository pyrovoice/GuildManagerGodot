extends Control

@onready var attribute = $HBoxContainer/attribute
@onready var value = $HBoxContainer/value

func init(_attribute: CombatAttributeEnum.att, _value: float):
	attribute.text = CombatAttributeEnum.getString(_attribute)
	value.text = str(_value)
