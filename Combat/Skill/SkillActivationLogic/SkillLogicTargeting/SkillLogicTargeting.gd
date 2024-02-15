extends Object
class_name SkillLogicTargeting

var preferredTargets: SkillActivationOptimalTargets.e

func getTargetsOrdered(combatant:CombatantInFight, combat: Combat, effectTargetType:SkillTargetEnum.t, lastAdded: Array[CombatantInFight]) -> Array[CombatantInFight]:
	if !SkillTargetEnum.skillTargetRequiresTarget(effectTargetType):
		return getAffectedNoTargeting(combatant, combat, effectTargetType, lastAdded)
	var d = filterTargetsByTargeting(combatant, combat).duplicate(true)
	sortGeneric(d)
	return d

func getAffectedNoTargeting(combatant:CombatantInFight, combat: Combat, effectTargetType: SkillTargetEnum.t, lastAdded: Array[CombatantInFight]) -> Array[CombatantInFight]:
	var arr: Array[CombatantInFight] = []
	match effectTargetType:
		SkillTargetEnum.t.SELF:
			arr.append(combatant)
		SkillTargetEnum.t.ALL:
			arr.append_array(combat.combatants.getTeam(0))
			arr.append_array(combat.combatants.getTeam(1))
		SkillTargetEnum.t.OTHERS:
			arr.append_array(combat.combatants.getTeam(0))
			arr.append_array(combat.combatants.getTeam(1))
			arr.remove_at(arr.find(combatant))
		SkillTargetEnum.t.ALL_OPPONENTS:
			arr.append_array(combat.combatants.getOpponentsOfCombatant(combatant))
		SkillTargetEnum.t.ALL_ALLY:
			arr.append_array(combat.combatants.getTeamOfCombatant(combatant))
		SkillTargetEnum.t.SAME_AS_PREVIOUS:
			arr.append_array(lastAdded)
		_:
			printerr("Missing implementation in SkillLogicTargeting getAffectedNoTargeting: " + str(effectTargetType))
	return arr
	
func filterTargetsByTargeting(combatant:CombatantInFight, combat: Combat, ) -> Array[CombatantInFight]:
	var arr: Array[CombatantInFight] = []
	match preferredTargets:
		SkillActivationOptimalTargets.e.ALLY, SkillActivationOptimalTargets.e.ALLY_AFFLICTED_STATUS_EFFECT, SkillActivationOptimalTargets.e.ALLY_LEAST_HEALTH :
			arr.append_array(combat.combatants.getTeamOfCombatant(combatant)) 
		SkillActivationOptimalTargets.e.BOSS, SkillActivationOptimalTargets.e.OPPONENT, SkillActivationOptimalTargets.e.OPPONENT_HIGHEST_DANGER, SkillActivationOptimalTargets.e.OPPONENT_LOWEST_HEALTH, SkillActivationOptimalTargets.e.OPPONENT_HIGHEST_HEALTH :
			arr.append_array(combat.combatants.getOpponentsOfCombatant(combatant))
		_:
			printerr("Missing implementation in SkillLogicTargeting filterTargetsByTargeting")
	return arr
	
# true = must switch, false = leave like this
func sortGeneric(targets: Array[CombatantInFight]) -> Array[CombatantInFight]:
	match preferredTargets:
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
			printerr("Missing implementation in SkillLogicTargeting sortGeneric for " + str(preferredTargets))
	return targets
