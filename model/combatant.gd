extends Object

class_name Combatant

var name: String = ""
var healthMax: float
var healthCurrent: float
var manaCurrent: float
var manaMax: float
var strength: float
var actionCooldown: float = 0
var timerToAct: float = 4
var skills: Array[Skill] = []

func _init(name: String="default name", health:float = 100, mana: float = 100, strength: float = 10):
	self.name = name
	self.healthMax = health
	self.healthCurrent = health
	self.manaMax = mana
	self.manaCurrent = mana
	self.strength = strength
	
	
func receiveDamage(damage: float):
	self.healthCurrent = clamp(self.healthCurrent - damage, 0, self.healthMax)

func update(delta):
	self.actionCooldown += delta

func canAct():
	return isAlive() && actionCooldown >= timerToAct

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
