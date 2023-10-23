extends Node
class_name CombatantDisplay

var combatant: Combatant = null
func init(c: Combatant):
	self.combatant = c
	updateDisplay()

func _process(_delta):
	updateDisplay()
	
func updateDisplay():
	if self.combatant != null:
		get_node("Health").text = str(self.combatant.healthCurrent, "/", self.combatant.healthMax)
		get_node("Mana").text = str(self.combatant.manaCurrent, "/", self.combatant.manaMax)
		get_node("Name").text = self.combatant.name
		get_node("HealthBar").max_value = self.combatant.healthMax
		get_node("HealthBar").value = self.combatant.healthCurrent
		get_node("ManaBar").max_value = self.combatant.manaMax
		get_node("ManaBar").value = self.combatant.manaMax
		get_node("ActionBar").max_value = self.combatant.timerToAct
		get_node("ActionBar").value = self.combatant.actionCooldown
		get_node("Attack").text = str(self.combatant.strength)
