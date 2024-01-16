extends ColorRect

@onready var skill_name = $SkillName
@onready var menu_button = $MenuButton
@onready var condition_holder = $HBoxContainer

signal buttonAction(b: bool)
signal mouseAction(entered: bool)
var skill

func _ready():
	init(SkillFactory.getSkillBasicAttack())

func init(_skill:Skill):
	self.skill = _skill
	skill_name.text = skill.name
	for c in condition_holder.get_children():
		c.queue_free()
	var button:OptionButton = OptionButton.new()
	condition_holder.add_child(button)
	for s in SkillFactory.getPossibleConditionsForSkill(_skill):
		button.add_item(s)
	button.item_selected.connect(func(index): SetAdditionalParameters(button.get_item_text(index)))
	button.selected = -1

func SetAdditionalParameters(selectedItem):
	for c in condition_holder.get_children():
		if c.get_index() == 0:
			continue
		c.queue_free()
	for additionalOptionArray in SkillFactory.getAdditionalParametersForConditions(selectedItem):
		var button:OptionButton = OptionButton.new()
		condition_holder.add_child(button)
		for additionalOption in additionalOptionArray:
			button.add_item(additionalOption)
	
func _on_menu_button_button_down():
	buttonAction.emit(true)


func _on_menu_button_button_up():
	buttonAction.emit(false)


func _on_mouse_entered():
	mouseAction.emit(true)


func _on_mouse_exited():
	mouseAction.emit(false)


#TODO Add a tooltip on button to explain what it does
func _on_add_condition_button_pressed():
	pass # Replace with function body.
