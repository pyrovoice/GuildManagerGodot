extends Control

@onready var grid_container = $MarginContainer/GridContainer
const inputData = ["String 1", "String 2", "String 3", "String 4", "String 5", "String 6"]
const skillLine = preload("res://SkillLine.tscn")
var draggedComponent: Control = null

func _ready():
	for child in grid_container.get_children():
		child.queue_free()
	for input in inputData:
		var newLine = skillLine.instantiate()
		grid_container.add_child(newLine)
		newLine.init(input)
		newLine.buttonAction.connect(func(b):onLineButtonPressed(newLine, b))
		newLine.mouseAction.connect(func(entered): onMouseEnterElement(newLine, entered))
		newLine.name = input

func onLineButtonPressed(child, isPressed: bool):
	if isPressed:
		draggedComponent = child
		draggedComponent.z_index = 1
		draggedComponent.menu_button.mouse_filter = MOUSE_FILTER_IGNORE
		draggedComponent.mouse_filter = MOUSE_FILTER_IGNORE
	elif draggedComponent:
		draggedComponent.menu_button.mouse_filter = MOUSE_FILTER_PASS
		draggedComponent.mouse_filter = MOUSE_FILTER_PASS
		draggedComponent.z_index = 0
		grid_container.queue_sort()
		print("Set position")
		draggedComponent = null

func onMouseEnterElement(enteredElement, isMouseEnter: bool):
	if draggedComponent && isMouseEnter && draggedComponent != enteredElement:
		grid_container.move_child(draggedComponent, enteredElement.get_index())

func _input(event):
	if event is InputEventMouseButton && !event.pressed && event.button_index == MOUSE_BUTTON_LEFT:
		onLineButtonPressed(draggedComponent, false)
	elif event is InputEventMouseMotion && draggedComponent:
		draggedComponent.position.y = get_global_mouse_position().y - draggedComponent.size.y/2
		print("Dragged")
	
