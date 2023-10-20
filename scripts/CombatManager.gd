extends Node

var combats: Array[Combat] = []
var displayedCombat: Combat = null
# Called when the node enters the scene tree for the first time.
func _ready():
	addCombat()
	addCombat()
	self.get_node("Button").pressed.connect(self.hideCombat)
	pass # Replace with function body.

func addCombat():
	var c = Combat.new()
	c.init()
	combats.push_back(c)
	var button = Button.new()
	button.text = "Combat"
	var i = combats.size()-1
	button.pressed.connect(func(): self.displayCombat(i))
	self.get_node("Combats").add_child(button)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for c in combats:
		c.process(_delta)
	pass

func hideCombat():
	for n in self.get_node("ContainerAllies").get_children():
		self.get_node("ContainerAllies").remove_child(n)
	for n in self.get_node("ContainerEnnemies").get_children():
		self.get_node("ContainerEnnemies").remove_child(n)
	self.get_node("Combats").set_visible(true)
		
func displayCombat(i: int):
	if combats.size()-1 < i:
		return;
	self.get_node("Combats").set_visible(false)
	for c in combats[i].combatantsPlayer:
		addCombatantToTeam(c, true)
	for c in combats[i].combatantsOpponent:
		addCombatantToTeam(c, false)
	
func addCombatantToTeam(c: Combatant, isAlly: bool):
	var cDisplay = preload("res://objects/combatant_display_combat.tscn").instantiate()
	if isAlly:
		self.get_node("ContainerAllies").add_child(cDisplay)
	else:
		self.get_node("ContainerEnnemies").add_child(cDisplay)
	cDisplay.init(c)
