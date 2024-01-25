extends Node
class_name CombatantDisplay

var combatant: CombatantInFight = null
func init(c: CombatantInFight):
	self.combatant = c
	updateDisplay()

func _process(_delta):
	updateDisplay()
	
func updateDisplay():
	if self.combatant != null:
		get_node("Health").text = str(self.combatant.healthCurrent, "/", self.combatant.combatantBased.getAttribute(CombatAttribute.att.HEALTH))
		get_node("Mana").text = str(self.combatant.manaCurrent, "/", self.combatant.combatantBased.getAttribute(CombatAttribute.att.MANA))
		get_node("Name").text = self.combatant.name
		get_node("HealthBar").max_value = self.combatant.combatantBased.getAttribute(CombatAttribute.att.HEALTH)
		get_node("HealthBar").value = self.combatant.healthCurrent
		get_node("ManaBar").max_value = self.combatant.combatantBased.getAttribute(CombatAttribute.att.MANA)
		get_node("ManaBar").value = self.combatant.manaCurrent
		get_node("ActionBar").max_value = self.combatant.delayToAct
		get_node("ActionBar").value = self.combatant.actionCooldown
		get_node("Attack").text = str(self.combatant.combatantBased.getAttribute(CombatAttribute.att.STRENGTH))
