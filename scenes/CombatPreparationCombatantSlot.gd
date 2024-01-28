extends ColorRect
class_name CombatPreparationCombatantSlot

signal onDrop(data)

func _can_drop_data(at_position, data):
	return data is CombatantInfoDisplaySmall

func _drop_data(at_position, data):
	onDrop.emit(data)
