extends Control

var combatantModificationNode
var combatantsDisplay

func _ready():
	combatantModificationNode = preload("res://objects/combatantModificationDisplay.tscn").instantiate()
	self.add_child(combatantModificationNode)
	combatantModificationNode.hide()
	(combatantModificationNode.get_node("Return") as Button).pressed.connect(self.showSelection)
	combatantsDisplay = preload("res://objects/CombatantSelection.tscn").instantiate()
	self.add_child(combatantsDisplay)
	showSelection()
	
func showSelection():
	combatantModificationNode.hide()
	combatantsDisplay.show()
	for c in combatantsDisplay.get_children():
		combatantsDisplay.remove_child(c)
	for c in PlayerData.getInstance().combatants:
		var b: Button = Button.new()
		b.text = c.name
		b.pressed.connect(func(): self.openModification(c))
		combatantsDisplay.add_child(b)

func openModification(c: Combatant):
	combatantsDisplay.hide()
	combatantModificationNode.setCombatant(c)
	combatantModificationNode.show()
