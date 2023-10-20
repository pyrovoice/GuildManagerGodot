extends Object
class_name Combat

var combatantsPlayer: Array[Combatant] = []
var combatantsOpponent: Array[Combatant] = []

func init():
	#Random hero life from 401 to 600
	var lifrHero = randi()%200+400
	addCombatantToTeam(Combatant.new("Hero", lifrHero, 100, 12), true)
	addCombatantToTeam(Combatant.new("Rat 1" ,25, 0, 5), false)
	addCombatantToTeam(Combatant.new("Rat 1" ,25, 0, 5), false)
	addCombatantToTeam(Combatant.new("Rat 1" ,25, 0, 5), false)
	addCombatantToTeam(Combatant.new("Rat King" ,100, 20, 20), false)

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
