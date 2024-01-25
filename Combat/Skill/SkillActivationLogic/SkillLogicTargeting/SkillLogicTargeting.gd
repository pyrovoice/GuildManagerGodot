extends Object
class_name SkillLogicTargeting

var targetting = SkillActivationOptimalTargets.e.OPPONENT_LOWEST_HEALTH

func getTargetsOrdered(combatant:CombatantInFight, combat: Combat) -> Array[CombatantInFight]:
	var d = filterTargetsByTargeting(combatant, combat).duplicate(true)
	sortGeneric(d)
	return d

func filterTargetsByTargeting(combatant:CombatantInFight, combat: Combat):
	match targetting:
		SkillActivationOptimalTargets.e.ALLY, SkillActivationOptimalTargets.e.ALLY_AFFLICTED_STATUS_EFFECT, SkillActivationOptimalTargets.e.ALLY_LEAST_HEALTH :
			return combat.getAllies(combatant)
		SkillActivationOptimalTargets.e.BOSS, SkillActivationOptimalTargets.e.OPPONENT, SkillActivationOptimalTargets.e.OPPONENT_HIGHEST_DANGER, SkillActivationOptimalTargets.e.OPPONENT_LOWEST_HEALTH, SkillActivationOptimalTargets.e.OPPONENT_HIGHEST_HEALTH :
			return combat.getOpponents(combatant)
		_:
			printerr("Missing implementation in SkillLogicTargeting filterTargetsByTargeting")
			return []

# true = must switch, false = leave like this
func sortGeneric(targets: Array[CombatantInFight]) -> Array[CombatantInFight]:
	match targetting:
		SkillActivationOptimalTargets.e.ALLY, SkillActivationOptimalTargets.e.OPPONENT:
			targets.shuffle()
		SkillActivationOptimalTargets.e.ALLY_LEAST_HEALTH, SkillActivationOptimalTargets.e.OPPONENT_LOWEST_HEALTH:
			targets.sort_custom(func(a:CombatantInFight , b: CombatantInFight):
				return a.healthCurrent < b.healthCurrent
			)
		SkillActivationOptimalTargets.e.OPPONENT_HIGHEST_HEALTH:
			targets.sort_custom(func(a:CombatantInFight , b: CombatantInFight):
				return a.healthCurrent > b.healthCurrent
			)
		_:
			printerr("Missing implementation in SkillLogicTargeting sortGeneric")
	return targets
