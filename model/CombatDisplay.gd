extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	var eiiegn = preload("res://objects/locationsDisplay.tscn").instantiate()
	eiiegn.name = "locationsDisplay"
	self.add_child(eiiegn)
	eiiegn = preload("res://objects/locationCombatantSelector.tscn").instantiate()
	eiiegn.name = "locationCombatantSelector"
	self.add_child(eiiegn)
	eiiegn = preload("res://objects/combat_display.tscn").instantiate()
	eiiegn.name = "combat_display"
	self.add_child(eiiegn)
	self.get_node("locationCombatantSelector/Validate").pressed.connect(self.startCombat)
	self.get_node("combat_display/Delete").pressed.connect(self.stopCombat)
	displayLocations()
	pass # Replace with function body.

func init():
	displayLocations()
	
func updateLocationList():
	var ogier = self.get_node("locationsDisplay/Locations/GridContainer")
	for i in ogier.get_children():
		self.get_node("locationsDisplay/Locations/GridContainer").remove_child(i)
	ogier = self.get_node("locationsDisplay/ActiveCombats/GridContainer")
	for i in ogier.get_children():
		self.get_node("locationsDisplay/ActiveCombats/GridContainer").remove_child(i)
	var i = 0
	for l in PlayerData.getInstance().unlockedLocation:
		var button = Button.new()
		button.text = l
		button.pressed.connect(func(): self.displayCombatPreparation(l))
		self.get_node("locationsDisplay/Locations/GridContainer").add_child(button)
		i = i+1
	for c in CombatManager.getInstance().combats:
		var button = Button.new()
		button.text = c.name
		button.pressed.connect(func(): self.displayCombat(c))
		self.get_node("locationsDisplay/ActiveCombats/GridContainer").add_child(button)
		i = i+1

func hideAll():
	for i in self.get_children():
		i.hide()
	currentlyDisplayedCombat = null
	selectedCombatants = []
	
func displayLocations():
	hideAll()
	updateLocationList()
	self.get_node("locationsDisplay").show()
	
var selectedCombatants: Array[Combatant] = []
var lastLocationName = ""
func displayCombatPreparation(locationName: String):
	hideAll()
	lastLocationName = locationName
	for i in self.get_node("locationCombatantSelector/AvailableCombatants/GridContainer").get_children():
		self.get_node("locationCombatantSelector/AvailableCombatants/GridContainer").remove_child(i)
	var combatants = GameMaster.getInstance().getAvailableCombatants()
	for c in combatants:
		var button = Button.new()
		button.text = c.name
		button.toggle_mode = true
		button.pressed.connect(func(): addOrRemoveFromSelection(c))
		self.get_node("locationCombatantSelector/AvailableCombatants/GridContainer").add_child(button)
	self.get_node("locationCombatantSelector").show()

func startCombat():
	if(selectedCombatants.size() == 0):
		print("No combatant selected for combat")
		return
	var startedC = CombatManager.getInstance().addCombat(lastLocationName, selectedCombatants)
	if startedC == null:
		print("Combat failed to start")
		return
		
	displayCombat(startedC)
	
func addOrRemoveFromSelection(c: Combatant):
	if selectedCombatants.has(c):
		selectedCombatants.erase(c)
	else:
		selectedCombatants.push_back(c)

var currentlyDisplayedCombat = null
func displayCombat(combat: Combat):
	if !CombatManager.getInstance().combats.has(combat):
		print("Display combat failed for " + combat.name)
		return
	hideAll()
	currentlyDisplayedCombat = combat
	for n in self.get_node("combat_display/ContainerAllies").get_children():
		self.get_node("combat_display/ContainerAllies").remove_child(n)
	for n in self.get_node("combat_display/ContainerEnnemies").get_children():
		self.get_node("combat_display/ContainerEnnemies").remove_child(n)
	for c in combat.combatantsPlayer:
		addCombatantToTeam(c, true)
	for c in combat.combatantsOpponent:
		addCombatantToTeam(c, false)
	self.get_node("combat_display").show()

	
func addCombatantToTeam(c: CombatantInFight, isAlly: bool):
	var cDisplay = preload("res://objects/combatant_display_combat.tscn").instantiate()
	if isAlly:
		self.get_node("combat_display/ContainerAllies").add_child(cDisplay)
	else:
		self.get_node("combat_display/ContainerEnnemies").add_child(cDisplay)
	cDisplay.init(c)
	

func stopCombat():
	CombatManager.getInstance().stopCombat(currentlyDisplayedCombat)
	self.displayLocations()
