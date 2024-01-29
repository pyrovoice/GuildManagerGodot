extends Object
class_name Combat

var location: FightingLocation
var combatantsPlayerSpaces: Array[Array]
var combatantsOpponentSpaces: Array[Array]
var encounterCounter = 1
var level = 1
signal combatantsChange

func init(combatantsFront: Array[Combatant], combatantsBack: Array[Combatant], l: FightingLocation):
	self.location = l
	combatantsPlayerSpaces = initSpacesForCombatants()
	combatantsOpponentSpaces = initSpacesForCombatants()
	for c in combatantsFront:
		if c == null:
			continue
		addCombatantToTeam(CombatantInFight.new(c), true, true, combatantsFront.find(c))
	for c in combatantsBack:
		if c == null:
			continue
		addCombatantToTeam(CombatantInFight.new(c), true, false, combatantsBack.find(c))
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
	for combatant in getCombatants(true):
		updateCombatant(combatant, delta)
	for combatant in getCombatants(false):
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
	combatantsOpponentSpaces = initSpacesForCombatants()
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
	
func addCombatantToTeam(c: CombatantInFight, isAlly: bool, isInFront: bool = true, position: int = -1):
	if c == null:
		return
	var frontOrBack = 0 if isInFront else 1
	var spaceToAdd = combatantsPlayerSpaces if isAlly else combatantsOpponentSpaces
	var emptySpace = position if position != -1 && spaceToAdd[frontOrBack][position] == null else spaceToAdd[frontOrBack].find(null)
	if emptySpace != -1:
		spaceToAdd[frontOrBack][emptySpace] = c
	else:
		frontOrBack = 0 if !isInFront else 1
		emptySpace = spaceToAdd[frontOrBack].find(null)
		if emptySpace != -1:
			spaceToAdd[frontOrBack][emptySpace] = c
			print("Added combatant in other row due to lack of space")
		else:
			printerr("Couldn't add combatant due to lack of space")
		
		
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
	for c in getCombatants(true):
		if c == combatant:
			isAlly = true
			break
	if isAlly:
		return getCombatants(false)
	else:
		return getCombatants(true)
		
func getAllies(combatant: CombatantInFight):
	var isAlly = false
	for c in getCombatants(true):
		if c == combatant:
			isAlly = true
			break
	if isAlly:
		return getCombatants(true)
	else:
		return getCombatants(false)

#Returns 1 if player wins, -1 if opponents win, 0 if no winner yet
func getWinningTeam():
	var alliesDead = true
	var ennemiesDead = true
	for c in getCombatants(true):
		var b = c.isAlive()
		if b:
			alliesDead = false
			break
	for c in getCombatants(false):
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

func getCombatants(allies: bool) -> Array[CombatantInFight]:
	var arrayToLookAt = combatantsPlayerSpaces if allies else combatantsOpponentSpaces
	var combatants = arrayToLookAt[0].filter(func(b): return b != null)
	combatants.append_array(arrayToLookAt[1].filter(func(b): return b != null))
	return combatants
	
func resetPlayerCombatants():
	for sides in self.combatantsPlayerSpaces:
		for c in sides:
			if c != null:
				sides[sides.find(c)] = CombatantInFight.new(c.combatantBased)
	combatantsChange.emit()
