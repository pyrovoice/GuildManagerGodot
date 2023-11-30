extends Control
class_name DraggeableEquipment

signal onClick
var equipment: Equipable = null

func init(e: Equipable):
	self.equipment = e
	self.get_node("Name").text = equipment.name
	self.get_node("Stats").text = str(equipment.bonusHealth)+ "\n" + str(equipment.bonusMana) + "\n" + str(equipment.bonusAttack)
	var equippredTo = PlayerData.getInstance().getEquippedTo(e)
	if equippredTo:
		self.get_node("EquippedTo").text = "(" + equippredTo.name + ")"
	else:
		self.get_node("EquippedTo").text = ""
	
	
func _get_drag_data(_pos):
	var data = equipment
	
	var drag_texture: TextureRect = TextureRect.new()
	drag_texture.expand = true 
	drag_texture.texture = self.get_node("EquipmentType").texture
	drag_texture.size = Vector2(100, 100) 
	
	var preview = Control.new()
	preview.add_child(drag_texture)
	drag_texture.position = -0.5*drag_texture.size
	set_drag_preview(preview)
	return data
	
func _can_drop_data(at_position, data):
	return true
	
func _drop_data(at_position, data):
	pass
	
func _gui_input(event): 
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			onClick.emit()
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_LEFT and (event as InputEventMouseButton).is_double_click():
			onClick.emit()
