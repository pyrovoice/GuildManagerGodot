extends Resource
class_name Combat

@export var location: FightingLocation
@export var combatants: CombatPositionsCombatant
@export var encounterCounter = 1
@export var level = 1

signal combatantsChange
signal on_combat_action

static func create(combatantsFront: Array[Combatant], combatantsBack: Array[Combatant], l: FightingLocation):
	var a: Combat = Combat.new()
	a.location = l
	a.combatants = CombatPositionsCombatant.create(Vector2(5, 2), combatantsFront, combatantsBack)
	a.addOpponentForLevel()
	return a
	
func initSpacesForCombatants() -> Array[Array]:
	var combatantSpaces:Array[Array] = []
	var spacesFront: Array[CombatantInFight] = []
	spacesFront.resize(5)
	var spacesBack: Array[CombatantInFight] = []
	spacesBack.resize(5)
	combatantSpaces.push_back(spacesFront)
	combatantSpaces.push_back(spacesBack)
	return combatantSpaces
	
func process(delta):
	for combatant in combatants.getTeam(true):
		updateCombatant(combatant, delta)
	for combatant in combatants.getTeam(false):
		updateCombatant(combatant, delta)
	var winningResult = getWinningTeam()
	if winningResult == 1:
		GameMaster.getInstance().addRewardForCombat(self)
		incrementeLevel()
		addOpponentForLevel()
		combatantsChange.emit()
	elif winningResult == -1:
		resetPlayerCombatants()
		encounterCounter = 1
		addOpponentForLevel()
		combatantsChange.emit()
		
func addOpponentForLevel():
	combatants.opponentCombatants = []
	if self.encounterCounter == self.location.encounterPerLevel:
		for o in self.location.bossEncounter:
			var opponent = GameData.getInstance().getOpponent(o)
			if opponent:
				combatants.addCombatantAtLocation(Vector2(-1, -1), opponent, false)
	else:
		var targetOpponentCount = location.averageEncounterDifficulty + (randi()%(location.difficultyVariance*2)-location.difficultyVariance)
		var opponentCount = 0
		while opponentCount < targetOpponentCount:
			var size = location.possibleOpponents.size()
			var random_key = location.possibleOpponents.keys()[randi() % size]
			var opponent = GameData.getInstance().getOpponent(random_key)
			if opponent:
				opponentCount += location.possibleOpponents[random_key]
				combatants.addCombatantAtLocation(Vector2(-1, -1), opponent, false)

func incrementeLevel():
	self.encounterCounter += 1
	if encounterCounter > self.location.encounterPerLevel:
		encounterCounter = 1
		level += 1
		resetPlayerCombatants()
		
func updateCombatant(combatant: CombatantInFight, delta: float):
	combatant.update(delta)
	if combatant.canAct():
		resolveAction(combatant)

func resolveAction(source: CombatantInFight):
	var skill:ActivatedSkillData = getActionForCombatant(source)
	if skill == null:
		print("Skill null for:" + source.name)
		return
	source.actionCooldown = 0
	for effect in skill.getEffects():
		var log = resolveEffect(source, effect, skill.effectToTargetsDic[effect])
		if log:
			skill.skillLog.fragments.append(log)
	on_combat_action.emit(skill, self.duplicate(true))
		
func getActionForCombatant(combatant: CombatantInFight) -> ActivatedSkillData:
	if(combatant.name == "Hero"):
		print(str(PlayerData.getInstance().combatants[0].combatantStrategy.orderedSkillActivationStrategy.size()))
		print(str(combatant.combatantBased.combatantStrategy.orderedSkillActivationStrategy.size()))
	for skillStrategy in combatant.combatantBased.combatantStrategy.orderedSkillActivationStrategy:
		if combatant.canActivateSkill(skillStrategy) && skillStrategy.canActivate(combatant):
			var targetsFiltered = getSkillTargets(skillStrategy, combatant)
			if targetsFiltered != {}:
				return ActivatedSkillData.new(combatant, skillStrategy.skill, targetsFiltered)
	return null

#return {} if not castable, return a Dic<EffectDescriptor, Targets> otherwise. 
#If so, the skill is castable no other checks required
func getSkillTargets(skillStrategy: SkillLogicStrategy, combatant: CombatantInFight) -> Dictionary:
	var preferedTargetsForEffectDic = {}
	var lastAdded: Array[CombatantInFight] = []
	for effectDescriptor: EffectDescriptor in skillStrategy.effectToSkillLogicTargetingDic.keys():
		var strategyForEffect: SkillLogicTargeting = skillStrategy.effectToSkillLogicTargetingDic[effectDescriptor]
		var targets: Array[CombatantInFight] = strategyForEffect.getTargetsOrdered(combatant, self, effectDescriptor.targetType, lastAdded)
		lastAdded = targets
		var targetsFiltered = targets.filter(func(t): return combatantCanTarget(combatant, t, effectDescriptor))
		if targetsFiltered.size() < effectDescriptor.requiredTargets:
			return {}
		var maxNumberTargets = effectDescriptor.requiredTargets + effectDescriptor.optionalTargets
		if targetsFiltered.size() > maxNumberTargets:
			targetsFiltered = targetsFiltered.slice(0, maxNumberTargets)
		preferedTargetsForEffectDic[effectDescriptor] = targetsFiltered
	return preferedTargetsForEffectDic
	
func combatantCanTarget(combatant: CombatantInFight, target: CombatantInFight, effect: EffectDescriptor):
	var b = target.isAlive()
	var isInRange = combatants.getDistanceBetweenTwoCombatants(combatant, target)
	return b && isInRange != -1 && isInRange <= effect.range

func resolveEffect(activator: CombatantInFight, effect: EffectDescriptor, targets: Array[CombatantInFight]) -> SkillLogFragment:
	match effect.effectType:
		EffectDecriptorType.e.DAMAGE:
			for target in targets:
				var inflictedDamage = target.receiveDamage(getEffectFinalValue(activator, effect))
				return SkillLogFragment.new(SkillLogFragment.SLFType.DAMAGE_INFLICTED, inflictedDamage, effect, target)
		EffectDecriptorType.e.HEAL:
			for target in targets:
				var v = target.receiveHealing(getEffectFinalValue(activator, effect))
				return SkillLogFragment.new(SkillLogFragment.SLFType.HEAL, v, effect, target)
		EffectDecriptorType.e.DISPLACE:
			for target in targets:
				combatants.moveCombatantSwitchRow(target)
				return SkillLogFragment.new(SkillLogFragment.SLFType.MOVE, 0, effect, target)
	return null

func getEffectFinalValue(activator: CombatantInFight, effect: EffectDescriptor)-> float:
	var total = effect.baseValue
	for effectScaling in effect.scalings.keys():
		var combatantAttribute = activator.getAttribute(effectScaling)
		if combatantAttribute != null:
			total += combatantAttribute*effect.scalings[effectScaling]
	return total

#Returns 1 if player wins, -1 if opponents win, 0 if no winner yet
func getWinningTeam():
	var alliesDead = true
	var ennemiesDead = true
	for c in combatants.getTeam(true):
		var b = c.isAlive()
		if b:
			alliesDead = false
			break
	for c in combatants.getTeam(false):
		var b = c.isAlive()
		if b:
			ennemiesDead = false
			break
	if alliesDead:
		return -1
	elif ennemiesDead:
		return 1
	else:
		return 0
	
func resetPlayerCombatants():
	var alliedTeam = combatants.getTeam(true)
	for c in alliedTeam:
		c.reset()
	combatantsChange.emit()

func getCombatants() -> Array:
	var arr = []
	arr.append_array(combatants.getTeam(true))
	arr.append_array(combatants.getTeam(false))
	return arr
