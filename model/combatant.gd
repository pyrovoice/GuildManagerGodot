extends Object

class_name Combatant

var name: String = "default name"
var healthMax: float
var healthCurrent: float
var manaCurrent: float
var manaMax: float
var strength: float
var actionCooldown: float = 0
var timerToAct: float = 4
var skills: Array[Skill] = []
var equipmentSlots = 2
var equippableEquipped = []

func _init(_name: String, _health:float = 100, _mana: float = 100, _strength: float = 10):
	self.name = _name
	self.healthMax = _health
	self.healthCurrent = _health
	self.manaMax = _mana
	self.manaCurrent = _mana
	self.strength = _strength
	
	
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
