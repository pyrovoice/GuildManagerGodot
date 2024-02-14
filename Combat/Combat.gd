extends Object
class_name Combat

var location: FightingLocation
var combatants: CombatPositionsCombatant
var encounterCounter = 1
var level = 1
signal combatantsChange

func init(combatantsFront: Array[Combatant], combatantsBack: Array[Combatant], l: FightingLocation):
	self.location = l
	combatants = CombatPositionsCombatant.new(Vector2(5, 2), combatantsFront, combatantsBack)
	addOpponentForLevel()
	
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
		return
	source.actionCooldown = 0
	print(skill.getLog())
	for effect in skill.effectToTargetsDic.keys():
		resolveEffect(source, effect, skill.effectToTargetsDic[effect])
		
func getActionForCombatant(combatant: CombatantInFight) -> ActivatedSkillData:
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

func resolveEffect(activator: CombatantInFight, effect: EffectDescriptor, targets: Array[CombatantInFight]):
	match effect.effectType:
		EffectDecriptorType.DAMAGE:
			for target in targets:
				target.receiveDamage(getEffectFinalValue(activator, effect))
		EffectDecriptorType.HEAL:
			for target in targets:
				target.receiveHealing(getEffectFinalValue(activator, effect))
		EffectDecriptorType.DISPLACE:
			for target in targets:
				combatants.moveCombatantSwitchRow(target)
			self.combatantsChange.emit()

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
