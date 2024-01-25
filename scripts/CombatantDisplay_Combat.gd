extends Node
class_name CombatantDisplay

@onready var health_bar = $HealthBar
@onready var health = $HealthBar/Health
@onready var mana_bar = $ManaBar
@onready var mana = $ManaBar/Mana
@onready var action_bar = $ActionBar

var combatant: CombatantInFight = null
func init(c: CombatantInFight):
	self.combatant = c
	updateDisplay()

func _process(_delta):
	updateDisplay()
	
func updateDisplay():
	if self.combatant != null:
		health.text = str(self.combatant.healthCurrent, "/", self.combatant.getAttribute(CombatAttributeEnum.att.HEALTH))
		mana.text = str(self.combatant.manaCurrent, "/", self.combatant.getAttribute(CombatAttributeEnum.att.MANA))
		get_node("Name").text = self.combatant.name
		health_bar.max_value = self.combatant.getAttribute(CombatAttributeEnum.att.HEALTH)
		health_bar.value = self.combatant.healthCurrent
		mana_bar.max_value = self.combatant.getAttribute(CombatAttributeEnum.att.MANA)
		mana_bar.value = self.combatant.manaCurrent
		get_node("ActionBar").max_value = self.combatant.delayToAct
		get_node("ActionBar").value = self.combatant.actionCooldown
		get_node("Attack").text = str(self.combatant.getAttribute(CombatAttributeEnum.att.STRENGTH))
