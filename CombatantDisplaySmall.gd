extends Control
class_name CombatantInfoDisplaySmall

@onready var combatantName = $Name
@onready var stats_grid = $MarginContainer/StatsGrid
const attributeDisplay = preload("res://scenes/StatisticDisplay.tscn")
var combatant: Combatant = null
@onready var color_rect = $ColorRect
signal onClicked(event: InputEventMouseButton)

func _ready():
	var c = Combatant.new("Test")
	init(c)
	
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
	var preview = Control.new()
	var copy = self.duplicate()
	preview.add_child(copy)
	copy.position = self.get_size() *0.1
	set_drag_preview(preview)
	return self

var isMouseInside = false
func _on_mouse_exited():
	isMouseInside = false

func _on_mouse_entered():
	isMouseInside = true

func _on_gui_input(event):
	if event is InputEventMouseButton && isMouseInside:
		onClicked.emit(event)
