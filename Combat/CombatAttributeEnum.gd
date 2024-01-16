class_name CombatAttribute
enum{
	HEALTH,
	MANA,
	STRENGTH,
	POWER
}

static func getString(value: CombatAttribute) -> String:
	return CombatAttribute.keys()[value]
