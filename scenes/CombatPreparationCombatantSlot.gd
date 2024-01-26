extends ColorRect
class_name CombatPreparationCombatantSlot

func _can_drop_data(at_position, data):
	return data is CombatantInfoDisplaySmall

func _drop_data(at_position, data):
	add_child(data)
	
func _input_event(viewport, event: InputEvent, shape_idx):
	if event.type == InputEventMouseButton \
	and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		var string = "Clicked! "
		var a = get_child(0)
		if a:
			string += a.combatant.name
		print(string)
