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
	var skill:ActivatedSkillData = source.triggerAction(self)
	if skill == null:
		return
	for effect in skill.skillParts:
		resolveEffect(skill, effect)

#TODO add targeting, pass whole target and skill to resolve, add multiple skills, add Stamina for all actions
func resolveEffect(skill: ActivatedSkillData, effect: EffectDescriptor):
	match effect.EffectDescriptorType:
		EffectDecriptorType.DAMAGE:
			for target in skill.targets:
				target.receiveDamage(getEffectFinalValue(skill, effect))
		EffectDecriptorType.HEAL:
			for target in skill.targets:
				target.receiveHealing(getEffectFinalValue(skill, effect))

func getEffectFinalValue(skill: ActivatedSkillData, effect: EffectDescriptor)-> float:
	var total = effect.baseValue
	for effectScalings in effect.scalings.keys():
		if skill.activator.attributes.find_key(effectScalings) != null:
			total += skill.activator.attributes[effectScalings]*effect.scalings[effectScalings]
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
		
func getRandomTargetablOpponent(combatant: CombatantInFight, amountTargets: int) -> Array[CombatantInFight]:
	var opps = getOpponents(combatant)
	opps = opps.filter(func(c): return c.isAlive() > 0)
	var selectedOpps = []
	while opps.size() > 0 && selectedOpps.size() < amountTargets:
		var s = opps[randi() % opps.size()]
		selectedOpps.push_back(s)
		opps.remove_at(opps.find(s))
	return selectedOpps
	
func getRandomTargetablAlly(combatant: CombatantInFight, amountTargets: int) -> Array[CombatantInFight]:
	pass

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
		c = CombatantInFight.new(c.combatantBased)
