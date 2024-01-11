extends ColorRect

@onready var label = $Label
@onready var menu_button = $MenuButton
signal buttonAction(b: bool)
signal mouseAction(entered: bool)

func init(string:String):
	label.text = string
	
func _on_menu_button_button_down():
	buttonAction.emit(true)


func _on_menu_button_button_up():
	buttonAction.emit(false)


func _on_mouse_entered():
	mouseAction.emit(true)


func _on_mouse_exited():
	mouseAction.emit(false)
