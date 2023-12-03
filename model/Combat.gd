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
		resolveAction(combatant, combatant.triggerAction())

func resolveAction(source: CombatantInFight, effects: Array[EffectDescriptor]):
	for effect in effects:
		resolveEffect(source, effect)
	
func resolveEffect(source: CombatantInFight, effect: EffectDescriptor):
	if(effect.EffectDescriptorType == EffectDecriptorType.REDUCE):
		var opps = getOpponents(source)
		opps = opps.filter(func(c): return c.healthCurrent > 0)
		if(opps.size() == 0):
			return
		var target = opps[randi() % opps.size()] as CombatantInFight
		target.healthCurrent -= (effect.baseValue + source.strength)
		
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
