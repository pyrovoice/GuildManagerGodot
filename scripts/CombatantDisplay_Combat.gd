extends Node

var c: Combatant = null
func init(Combatant):
	self.c = Combatant
	if c != null:
		self.connect("on_value_change", updateDisplay)
		updateDisplay()

func _process(delta):
	updateDisplay()
	
func updateDisplay(c: Combatant = null):
	get_node("Health").text = str(self.c.healthCurrent, "/", self.c.healthMax)
	get_node("Mana").text = str(self.c.manaCurrent, "/", self.c.manaMax)
	get_node("Name").text = c.name
	get_node("HealthBar").max_value = self.c.healthMax
	get_node("HealthBar").value = self.c.healthMax
	get_node("ManaBar").max_value = self.c.manaMax
	get_node("ManaBar").value = self.c.manaMax
