class_name CombatAttribute
enum att{
	HEALTH,
	MANA,
	STRENGTH,
	POWER
}

static func getString(value: CombatAttribute) -> String:
	return CombatAttribute.att.keys()[value]
