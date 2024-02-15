extends ColorRect
class_name SkillLine

@onready var skill_name = $SkillName
@onready var menu_button = $MenuButton
@onready var target_container = $TargetContainer
@onready var activationConditionContainer = $MarginContainer/VBoxContainer
const ACTIVATION_CONDITION = preload("uid://boavwn27odb54")

signal buttonAction(b: bool)
signal mouseAction(entered: bool)
var skillLogicStrategy:SkillLogicStrategy

func _ready():
	initDefault(SkillFactory.getSkillChangeRow())
	initDefault(SkillFactory.getSkillBasicAttack())

func initDefault(_skill:Skill):
	init(SkillFactory.getDefaultLogicForSkill(_skill))
	
func init(skillLogic:SkillLogicStrategy):
	reset()
	self.skillLogicStrategy = skillLogic
	skill_name.text = skillLogic.skill.name
	#Prefered target
	var targetDropdown:OptionButton = OptionButton.new()
	target_container.add_child(targetDropdown)
	var possibleTargets = SkillActivationOptimalTargets.e.keys()
	for possibleTargeting in SkillActivationOptimalTargets.e.keys():
		targetDropdown.add_item(possibleTargeting)
		if skillLogic.defaultTargetting.targetting == SkillActivationOptimalTargets.e.find_key(possibleTargeting):
			targetDropdown._select_int(targetDropdown.item_count-1)
	targetDropdown.item_selected.connect(func(index): setTargeting(possibleTargets, index))
	targetDropdown.selected = -1
	#Activation Conditions
	var conditionButton:OptionButton = OptionButton.new()
	for activationCondition in skillLogic.activationConditions:
		var conditionLine = ACTIVATION_CONDITION.instantiate()
		activationConditionContainer.add_child(conditionLine)
		conditionLine.init(activationCondition)

func setTargeting(possibletargets, selectedTargeting):
	var d = possibletargets[selectedTargeting]
	self.skillLogicStrategy.defaultTargetting.targetting = d
	
func reset():
	skill_name.text = ""
	self.skillLogicStrategy = null
	for c in target_container.get_children():
		c.queue_free()
	for c in activationConditionContainer.get_children():
		if c is Button:
			continue
		c.queue_free()
	
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
