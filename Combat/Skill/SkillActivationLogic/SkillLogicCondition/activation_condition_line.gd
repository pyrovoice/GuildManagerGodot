extends ColorRect
class_name ActivationConditionLine

@onready var h_box_container = $HBoxContainer
var skillLogicCondition:SkillLogicCondition

func init(_skillLogicCondition: SkillLogicCondition):
	skillLogicCondition = _skillLogicCondition
	for child in h_box_container.get_children():
		child.queue_free()
	for node in _skillLogicCondition.getAdditionalRequirement():
		h_box_container.add_child(node)
