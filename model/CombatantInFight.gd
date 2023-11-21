extends Object
class_name CombatantInFight

var combatantBased: Combatant

var name: String = "default name"
var healthMax: float
var healthCurrent: float
var manaCurrent: float
var manaMax: float
var strength: float
var actionCooldown: float = 0
var delayToAct: float = 4
var skills: Array[Skill] = []
var equippableEquipped: Array[Equipable] = []

func _init(c: Combatant):
	combatantBased = c
	name = c.name
	healthMax = c.health
	manaMax = c.mana
	strength = c.strength
	delayToAct = c.delayToAct
	skills = c.skills
	equippableEquipped = c.equippableEquipped.duplicate(true)
	for e in equippableEquipped:
		healthMax += e.bonusHealth
		manaMax += e.bonusMana
		strength += e.bonusAttack
	reset()

func receiveDamage(damage: float):
	self.healthCurrent = clamp(self.healthCurrent - damage, 0, self.healthMax)

func update(delta):
	self.actionCooldown += delta

func canAct():
	return isAlive() && actionCooldown >= delayToAct

func triggerAction():
	if self.skills.size() == 0:
		var s = Skill.new()
		s.name = "Basic Attack"
		s.isActive = true
		var skillPart = EffectDescriptor.new()
		s.skillParts.append(skillPart)
		self.skills.append(s)
	self.actionCooldown = 0
	return self.skills[0].skillParts

func isAlive():
	return self.healthCurrent > 0

func reset():
	self.healthCurrent = self.healthMax
	self.actionCooldown = 0
	self.manaCurrent = self.manaMax
