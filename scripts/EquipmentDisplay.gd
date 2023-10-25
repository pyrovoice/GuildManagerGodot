extends Control

var levelSelectionBox: SpinBox
var goldPerLevelMultiplier = 10
func _ready():
	levelSelectionBox = (self.get_node("LevelSelect") as SpinBox)
	levelSelectionBox.changed.connect(self.updateDisplay)
	self.get_node("MaxButton").pressed.connect(self.setSelectedLevelToMax)
	self.get_node("Validate").pressed.connect(self.createEquipment)


func _process(delta):
	self.get_node("PlayerGold").text = str(PlayerData.getInstance().gold)
	if levelSelectionBox.max_value != PlayerData.getInstance().maxCombatantLevel:
		levelSelectionBox.max_value = PlayerData.getInstance().maxCombatantLevel

func setSelectedLevelToMax():
	levelSelectionBox.value = getMaxLevelPossible()
	
func getMaxLevelPossible():
	return min(PlayerData.getInstance().gold/goldPerLevelMultiplier, PlayerData.getInstance().maxCombatantLevel)
	
func updateDisplay():
	(get_node("Cost")as Label).text = str(levelSelectionBox.value*goldPerLevelMultiplier)
	(get_node("preview")as Label).text = "Life: +" + str(levelSelectionBox.value*10)+ "Strength: +" + str(levelSelectionBox.value)
	
func createEquipment():
	var level = levelSelectionBox.value
	if (level * goldPerLevelMultiplier <= PlayerData.getInstance().gold 
		&&  level <= PlayerData.getInstance().maxCombatantLevel):
		PlayerData.getInstance().gold = PlayerData.getInstance().gold - level * goldPerLevelMultiplier
		PlayerData.getInstance().equipments.push_back(Equipable.new("Default", level *10, level, 0))
		var popup = AcceptDialog.new()
		popup.dialog_text = "New Equipment created"
		self.add_child(popup)
		popup.popup_centered()
		popup.show()
	else:
		var popup = AcceptDialog.new()
		popup.dialog_text = "Hero creation failed"
		self.add_child(popup)
		popup.popup_centered()
		popup.show()
