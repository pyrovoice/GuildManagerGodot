extends Object
class_name Combat

var location: FightingLocation
var combatantsPlayer: Array[CombatantInFight] = []
var combatantsOpponent: Array[CombatantInFight] = []
var encounterCounter = 1
var level = 1
signal combatantsChange

func init(combatants: Array[Combatant], l: FightingLocation):
	self.location = l
	for c in combatants:
		addCombatantToTeam(CombatantInFight.new(c), true)
	addOpponentForLevel()

func process(delta):
	for combatant in self.combatantsPlayer:
		updateCombatant(combatant, delta)
	for combatant in self.combatantsOpponent:
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
	combatantsOpponent = []
	if self.encounterCounter == self.location.encounterPerLevel:
		for o in self.location.bossEncounter:
			var opponent = GameData.getInstance().getOpponent(o)
			if opponent:
				addCombatantToTeam(CombatantInFight.new(opponent), false)
	else:
		var targetOpponentCount = location.averageEncounterDifficulty + (randi()%(location.difficultyVariance*2)-location.difficultyVariance)
		var opponentCount = 0
		while opponentCount < targetOpponentCount:
			var size = location.possibleOpponents.size()
			var random_key = location.possibleOpponents.keys()[randi() % size]
			var opponent = GameData.getInstance().getOpponent(random_key)
			if opponent:
				opponentCount += location.possibleOpponents[random_key]
				addCombatantToTeam(CombatantInFight.new(opponent), false)
	
func addCombatantToTeam(c: CombatantInFight, isAlly):
	if isAlly:
		self.combatantsPlayer.push_back(c)
	else:
		self.combatantsOpponent.push_back(c)
		
		
func incrementeLevel():
	self.encounterCounter += 1
	if encounterCounter > self.location.encounterPerLevel:
		encounterCounter = 1
		level += 1
		resetPlayerCombatants()
		
func updateCombatant(combatant: CombatantInFight, delta: float):
	combatant.actionCooldown += delta
	if combatant.canAct():
		resolveAction(combatant)

func resolveAction(source: CombatantInFight):
	var skill:ActivatedSkillData = getActionForCombatant(source)
	if skill == null:
		return
	source.actionCooldown = 0
	for effect in skill.skill.skillParts:
		resolveEffect(skill, effect)

func getActionForCombatant(combatant: CombatantInFight) -> ActivatedSkillData:
	for skillStrategy in combatant.combatantBased.combatantStrategy.orderedSkillActivationStrategy:
		if combatant.canActivateSkill(skillStrategy):
			var targets: Array[CombatantInFight] = skillStrategy.defaultTargetting.getTargetsOrdered(combatant, self)
			var targetsFiltered = targets.filter(func(t): return combatantCanTarget(combatant, t))
			targetsFiltered = skillStrategy.filterTargets(combatant, targetsFiltered)
			if targetsFiltered.size() >= skillStrategy.skill.requiredTargets:
				targetsFiltered = targetsFiltered.slice(0, skillStrategy.skill.requiredTargets)
				return ActivatedSkillData.new(combatant, skillStrategy.skill, targetsFiltered)
	return null

#TODO add check on placement (front and back, skill range)
func combatantCanTarget(combatant: CombatantInFight, target: CombatantInFight):
	var b = target.isAlive()
	return b

#TODO add targeting, pass whole target and skill to resolve, add multiple skills, add Stamina for all actions
func resolveEffect(skill: ActivatedSkillData, effect: EffectDescriptor):
	match effect.effectType:
		EffectDecriptorType.DAMAGE:
			for target in skill.targets:
				target.receiveDamage(getEffectFinalValue(skill, effect))
		EffectDecriptorType.HEAL:
			for target in skill.targets:
				target.receiveHealing(getEffectFinalValue(skill, effect))
				
func getEffectFinalValue(skill: ActivatedSkillData, effect: EffectDescriptor)-> float:
	var total = effect.baseValue
	for effectScaling in effect.scalings.keys():
		var combatantAttribute = skill.activator.getAttribute(effectScaling)
		if combatantAttribute != null:
			total += combatantAttribute*effect.scalings[effectScaling]
	return total
		
func getOpponents(combatant: CombatantInFight):
	var isAlly = false
	for c in combatantsPlayer:
		if c == combatant:
			isAlly = true
			break
	if isAlly:
		return self.combatantsOpponent
	else:
		return self.combatantsPlayer
		
func getAllies(combatant: CombatantInFight):
	var isAlly = false
	for c in combatantsPlayer:
		if c == combatant:
			isAlly = true
			break
	if isAlly:
		return self.combatantsPlayer
	else:
		return self.combatantsOpponent

#Returns 1 if player wins, -1 if opponents win, 0 if no winner yet
func getWinningTeam():
	var alliesDead = true
	var ennemiesDead = true
	for c in combatantsPlayer:
		var b = c.isAlive()
		if b:
			alliesDead = false
			break
	for c in combatantsOpponent:
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
	for c in self.combatantsPlayer:
		self.combatantsPlayer[self.combatantsPlayer.find(c)] = CombatantInFight.new(c.combatantBased)
	combatantsChange.emit()
