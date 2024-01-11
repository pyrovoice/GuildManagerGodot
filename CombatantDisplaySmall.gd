extends Control

@onready var combatantName = $Name
@onready var stats_grid = $MarginContainer/StatsGrid
const attributeDisplay = preload("res://scenes/StatisticDisplay.tscn")
var combatant: Combatant = null

func init(_combatant:Combatant):
	combatant = _combatant
	combatantName.text = combatant.name
	for child in stats_grid.children():
		child.queue_free()
	for key in combatant.attributes:
		var value = combatant.attributes[key]
		var ad = attributeDisplay.instantiate()
		stats_grid.add_child(ad)
		ad.init(key, value)
