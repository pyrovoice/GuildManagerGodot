class_name CombatAttributeEnum
enum att{
	HEALTH,
	MANA,
	STRENGTH,
	POWER
}

static func getString(value: CombatAttributeEnum.att) -> String:
	return CombatAttributeEnum.att.keys()[value]
