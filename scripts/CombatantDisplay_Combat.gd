extends Node

var c: Combatant = null
func init(c: Combatant):
	self.c = c
	updateDisplay()

func _process(_delta):
	updateDisplay()
	
func updateDisplay():
	if self.c != null:
		get_node("Health").text = str(self.c.healthCurrent, "/", self.c.healthMax)
		get_node("Mana").text = str(self.c.manaCurrent, "/", self.c.manaMax)
		get_node("Name").text = self.c.name
		get_node("HealthBar").max_value = self.c.healthMax
		get_node("HealthBar").value = self.c.healthMax
		get_node("ManaBar").max_value = self.c.manaMax
		get_node("ManaBar").value = self.c.manaMax
