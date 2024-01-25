extends ColorRect
class_name ActivationConditionLine

@onready var h_box_container = $HBoxContainer
var skillLogicCondition:SkillLogicCondition

func init(_skillLogicCondition: SkillLogicCondition):
	skillLogicCondition = _skillLogicCondition
	for child in h_box_container.get_children():
		child.queue_free()
	var conditionDropdown:OptionButton = OptionButton.new()
	h_box_container.add_child(conditionDropdown)
	conditionDropdown.item_selected.connect(onItemSelected)
	
func onItemSelected(index):
	for node in skillLogicCondition.getAdditionalRequirement():
		h_box_container.add_child(node)
