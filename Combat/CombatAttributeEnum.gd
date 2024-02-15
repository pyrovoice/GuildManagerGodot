class_name CombatAttributeEnum
enum att{
	HEALTH,
	MANA,
	STRENGTH,
	POWER
}

static func getString(value: CombatAttributeEnum.att) -> String:
	return CombatAttributeEnum.att.keys()[value]

static func getAttributeFromString(value: String) -> CombatAttributeEnum.att:
	var a = CombatAttributeEnum.att[value]
	return a
