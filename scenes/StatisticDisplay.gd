extends Control

@onready var attribute = $attribute
@onready var value = $value

func init(_attribute: CombatAttribute, _value: float):
	attribute.text = CombatAttribute.getString(_attribute)
	value = str(_value)