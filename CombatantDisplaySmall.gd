extends Control
class_name CombatantInfoDisplaySmall

@onready var combatantName = $Name
@onready var stats_grid = $MarginContainer/StatsGrid
const attributeDisplay = preload("res://scenes/StatisticDisplay.tscn")
var combatant: Combatant = null
@onready var color_rect = $ColorRect

func init(_combatant:Combatant):
	combatant = _combatant
	combatantName.text = combatant.name
	for child in stats_grid.get_children():
		child.queue_free()
	for key in combatant.attributes:
		var value = combatant.attributes[key]
		var ad = attributeDisplay.instantiate()
		stats_grid.add_child(ad)
		ad.init(key, value)

func _get_drag_data(_position):
	var icon = ColorRect.new()
	var preview = Control.new()
	icon.color = color_rect.color
	icon.position = icon.get_size() * -0.5
	preview.add_child(icon)
	set_drag_preview(preview)
	return self
