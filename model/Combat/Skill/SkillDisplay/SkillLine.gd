extends ColorRect

@onready var skill_name = $SkillName
@onready var menu_button = $MenuButton
signal buttonAction(b: bool)
signal mouseAction(entered: bool)
var skill

func init(_skill:Skill):
	self.skill = _skill
	skill_name.text = skill.name
	
func _on_menu_button_button_down():
	buttonAction.emit(true)


func _on_menu_button_button_up():
	buttonAction.emit(false)


func _on_mouse_entered():
	mouseAction.emit(true)


func _on_mouse_exited():
	mouseAction.emit(false)
