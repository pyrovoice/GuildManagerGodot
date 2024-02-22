extends Node

@onready var delete_combat = $DeleteCombat
const COMBAT_DISPLAY = preload("res://Combat/combat_display.tscn")
const COMBAT_PREPARATION_DISPLAY = preload("uid://c8oo4b7pbcewt")
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
		i.queue_free()
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
	var prep: LocationCombatPreparationDisplay = COMBAT_PREPARATION_DISPLAY.instantiate()
	add_child(prep)
	prep.init(location)
	prep.validated.connect(func(): startCombat(prep.getSelectedFrontRow(), prep.getSelectedBackRow()))

func startCombat(selectedCombatantsFront: Array[Combatant], selectedCombatantsBack: Array[Combatant]):
	if(selectedCombatantsFront.filter(func(pos): return pos != null).size() == 0 && \
	selectedCombatantsBack.filter(func(pos): return pos != null).size() == 0):
		print("No combatant selected for combat")
		return
	var startedC = CombatManager.getInstance().addCombat(lastLocation, selectedCombatantsFront, selectedCombatantsBack)
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
	var eiiegn = COMBAT_DISPLAY.instantiate()
	eiiegn.name = "combat_display"
	self.add_child(eiiegn)
	eiiegn.removeCombat.connect(self.stopCombat)
	eiiegn.init(combat)
	eiiegn.show()

func stopCombat():
	CombatManager.getInstance().stopCombat(currentlyDisplayedCombat)
	self.displayLocations()
