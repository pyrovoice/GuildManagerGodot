extends Object
class_name CombatantInFight

var combatantBased: Combatant

var name: String = "default name"
var attributes: Dictionary = {}
var healthCurrent: float
var manaCurrent: float
var actionCooldown: float = 0
var delayToAct: float = 4
var skills: Array[Skill] = []
var equippableEquipped: Array[Equipable] = []

func _init(c: Combatant):
	combatantBased = c
	name = c.name
	self.attributes[CombatAttribute.HEALTH] = c.health
	self.attributes[CombatAttribute.MANA] = c.mana
	self.attributes[CombatAttribute.STRENGTH] = c.strength
	delayToAct = c.delayToAct
	skills = c.skills
	if "equippableEquipped" in c:
		equippableEquipped = c.equippableEquipped.duplicate(true)
		for e in equippableEquipped:
			for attributeBonusType in e.attributes.keys():
				var newValue = self.attributes[attributeBonusType]
				if newValue == null: 
					newValue = 0
				newValue += e.attributes[attributeBonusType]
				self.attributes[attributeBonusType] = newValue
	reset()

func receiveDamage(damage: float):
	self.healthCurrent = clamp(self.healthCurrent - damage, 0, self.healthMax)

func update(delta):
	self.actionCooldown += delta

func canAct():
	return isAlive() && actionCooldown >= delayToAct

func triggerAction():
	self.actionCooldown = 0
	return self.skills[0]

func isAlive():
	return self.healthCurrent > 0

func reset():
	self.healthCurrent = self.healthMax
	self.actionCooldown = 0
	self.manaCurrent = self.manaMax
