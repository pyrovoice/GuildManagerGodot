extends Combatant
class_name Opponent

static func create(_opponentName = "", _health:float = 100, _mana: float = 100, _strength: float = 10) -> Opponent:
	var instance = Opponent.new()
	instance.name = _opponentName
	instance.attributes[CombatAttributeEnum.att.HEALTH] = _health
	instance.attributes[CombatAttributeEnum.att.MANA] = _mana
	instance.attributes[CombatAttributeEnum.att.STRENGTH] = _strength
	instance.skills.push_back(SkillFactory.getSkillChangeRow())
	instance.skills.push_back(SkillFactory.getSkillBasicAttack())
	instance.resetStrategyToDefault()
	return instance
