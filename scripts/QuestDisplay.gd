extends Control

const SKILL_ACTIVATION_LOGIC_TABLE = preload("uid://dq7j87fqj63gh")

func init():
	for ci in get_children():
		ci.queue_free()
	var c = PlayerData.getInstance().combatants[0]
	var skillTable = SKILL_ACTIVATION_LOGIC_TABLE.instantiate()
	add_child(skillTable)
	skillTable.init(c)
