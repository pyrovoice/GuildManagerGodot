extends Node

func init():
	displayLocations()
	
func updateLocationList():
	var locationsContainer = self.get_node("locationsDisplay/Locations/GridContainer")
	for i in locationsContainer.get_children():
		self.get_node("locationsDisplay/Locations/GridContainer").remove_child(i)
	locationsContainer = self.get_node("locationsDisplay/ActiveCombats/GridContainer")
	for i in locationsContainer.get_children():
		self.get_node("locationsDisplay/ActiveCombats/GridContainer").remove_child(i)
	var i = 0
	for l in PlayerData.getInstance().unlockedLocation:
		var button = Button.new()
		button.text = l.name
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
		self.remove_child(i)
	currentlyDisplayedCombat = null
	selectedCombatants = []
	
func displayLocations():
	hideAll()
	var eiiegn = preload("res://scenes/locationsDisplay.tscn").instantiate()
	eiiegn.name = "locationsDisplay"
	self.add_child(eiiegn)
	updateLocationList()
	
var selectedCombatants: Array[Combatant] = []
var lastLocation = null
func displayCombatPreparation(location: FightingLocation):
	hideAll()
	lastLocation = location
	var eiiegn = preload("res://scenes/locationCombatantSelector.tscn").instantiate()
	eiiegn.name = "locationCombatantSelector"
	eiiegn.get_node("Validate").pressed.connect(startCombat)
	self.add_child(eiiegn)
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
	var startedC = CombatManager.getInstance().addCombat(lastLocation, selectedCombatants)
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
	var eiiegn = preload("res://scenes/combat_display.tscn").instantiate()
	eiiegn.name = "combat_display"
	self.add_child(eiiegn)
	self.get_node("combat_display/Delete").pressed.connect(self.stopCombat)
	eiiegn.init(combat)
	eiiegn.show()

func stopCombat():
	CombatManager.getInstance().stopCombat(currentlyDisplayedCombat)
	self.displayLocations()
