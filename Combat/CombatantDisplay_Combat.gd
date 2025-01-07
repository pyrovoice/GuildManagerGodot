extends Node
class_name CombatantDisplay

@onready var health_bar = $CombatantDisplay_Combat/HealthBar
@onready var health = $CombatantDisplay_Combat/HealthBar/Health
@onready var mana_bar = $CombatantDisplay_Combat/ManaBar
@onready var mana = $CombatantDisplay_Combat/ManaBar/Mana
@onready var action_bar = $CombatantDisplay_Combat/ActionBar
@onready var cName = $CombatantDisplay_Combat/Name
@onready var attack = $CombatantDisplay_Combat/Attack

var combatant: CombatantInFight = null
func init(c: CombatantInFight):
	self.combatant = c
	updateValuePrivate(self.combatant)
	
func updateDisplay():
	updateValuePrivate(self.combatant)

func updateDisplayState(combatantState: CombatantInFight):
	if self.combatant != null && self.combatant.combatantBased == combatantState.combatantBased:
		updateValuePrivate(combatantState)
		
func updateValuePrivate(combatantState: CombatantInFight):
	if self.combatant != null && health:
		health.text = str(self.combatant.healthCurrent, "/", self.combatant.getAttribute(CombatAttributeEnum.att.HEALTH))
		mana.text = str(self.combatant.manaCurrent, "/", self.combatant.getAttribute(CombatAttributeEnum.att.MANA))
		cName.text = self.combatant.name
		health_bar.max_value = self.combatant.getAttribute(CombatAttributeEnum.att.HEALTH)
		health_bar.value = self.combatant.healthCurrent
		mana_bar.max_value = self.combatant.getAttribute(CombatAttributeEnum.att.MANA)
		mana_bar.value = self.combatant.manaCurrent
		action_bar.max_value = self.combatant.delayToAct
		action_bar.value = self.combatant.actionCooldown
		attack.text = str(self.combatant.getAttribute(CombatAttributeEnum.att.STRENGTH))
