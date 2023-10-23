extends Object
class_name Combat

static var cbCount = 0
var name: String = ""
var combatantsPlayer: Array[Combatant] = []
var combatantsOpponent: Array[Combatant] = []

func init(combatants: Array[Combatant]):
	for c in combatants:
		addCombatantToTeam(c, true)
	addCombatantToTeam(Combatant.new("Rat 1" ,25, 0, 5), false)
	addCombatantToTeam(Combatant.new("Rat 1" ,25, 0, 5), false)
	addCombatantToTeam(Combatant.new("Rat 1" ,25, 0, 5), false)
	#addCombatantToTeam(Combatant.new("Rat King" ,100, 20, 20), false)

func addCombatantToTeam(c: Combatant, isAlly):
	if isAlly:
		self.combatantsPlayer.push_back(c)
	else:
		self.combatantsOpponent.push_back(c)
		
func process(delta):
	for combatant in self.combatantsPlayer:
		updateCombatant(combatant, delta)
	for combatant in self.combatantsOpponent:
		updateCombatant(combatant, delta)
	pass

func updateCombatant(combatant: Combatant, delta: float):
	combatant.actionCooldown += delta
	if combatant.canAct():
		resolveAction(combatant, combatant.triggerAction())

func resolveAction(source: Combatant, effects: Array[EffectDescriptor]):
	for effect in effects:
		resolveEffect(source, effect)
	
func resolveEffect(source: Combatant, effect: EffectDescriptor):
	if(effect.EffectDescriptorType == EffectDecriptorType.REDUCE):
		var opps = getOpponents(source)
		opps = opps.filter(func(c): return c.healthCurrent > 0)
		if(opps.size() == 0):
			return
		var target = opps[randi() % opps.size()] as Combatant
		target.healthCurrent -= (effect.baseValue + source.strength)
		
func getOpponents(combatant: Combatant):
	var isAlly = false
	for c in combatantsPlayer:
		if c == combatant:
			isAlly = true
			break
	if isAlly:
		return self.combatantsOpponent
	else:
		return self.combatantsPlayer

func isCombatOver():
	#return !self.combatantsPlayer.any(func(combatant): combatant.isAlive()) || !self.combatantsOpponent.any(func(combatant): combatant.isAlive())
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
	return alliesDead || ennemiesDead

func resetCombatants():
	for combatant in self.combatantsPlayer:
		combatant.reset()
	for combatant in self.combatantsOpponent:
		combatant.reset()
