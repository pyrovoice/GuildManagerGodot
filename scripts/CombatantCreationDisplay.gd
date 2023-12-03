extends Control

var levelSelectionBox: SpinBox
var goldPerLevelMultiplier = 10
func _ready():
	var eiiegn = preload("res://scenes/CreationCombatant.tscn").instantiate()
	eiiegn.name = "CreationCombatant"
	self.add_child(eiiegn)
	levelSelectionBox = (self.get_node("CreationCombatant/SelectedLevel") as SpinBox)
	levelSelectionBox.changed.connect(self.updateCostDisplay)
	self.get_node("CreationCombatant/MaxLevel").pressed.connect(self.setSelectedLevelToMax)
	self.get_node("CreationCombatant/Validate").pressed.connect(self.createHero)


func _process(_delta):
	self.get_node("CreationCombatant/PlayerGold").text = str(PlayerData.getInstance().gold)
	if levelSelectionBox.max_value != PlayerData.getInstance().maxCombatantLevel:
		levelSelectionBox.max_value = PlayerData.getInstance().maxCombatantLevel

func setSelectedLevelToMax():
	levelSelectionBox.value = getMaxLevelPossible()
	
func getMaxLevelPossible():
	@warning_ignore("integer_division")
	return min(PlayerData.getInstance().gold/goldPerLevelMultiplier, PlayerData.getInstance().maxCombatantLevel)
	
func updateCostDisplay():
	(get_node("CreationCombatant/Cost")as Label).text = str(levelSelectionBox.value*goldPerLevelMultiplier)
	
func createHero():
	var level = levelSelectionBox.value
	if (level * goldPerLevelMultiplier <= PlayerData.getInstance().gold 
		&&  level <= PlayerData.getInstance().maxCombatantLevel):
		PlayerData.getInstance().gold = PlayerData.getInstance().gold - level * goldPerLevelMultiplier
		PlayerData.getInstance().combatants.push_back(Combatant.new("Default", level *100, level*20, level*5))
		var popup = AcceptDialog.new()
		popup.dialog_text = "New Hero created"
		self.add_child(popup)
		popup.popup_centered()
		popup.show()
	else:
		var popup = AcceptDialog.new()
		popup.dialog_text = "Hero creation failed"
		self.add_child(popup)
		popup.popup_centered()
		popup.show()
