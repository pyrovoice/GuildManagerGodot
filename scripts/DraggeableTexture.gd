extends TextureRect
class_name DraggeableTexture

func _get_drag_data(_pos):
	print("Called")
	var data = {}
	
	var drag_texture: TextureRect = TextureRect.new()
	drag_texture.expand = true 
	drag_texture.texture = self.texture
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
