extends Control

@onready var grid_container: GridContainer = $MarginContainer/GridContainer
@onready var dragged_label = $draggedLabel
var beingMoved = null

func _ready():
	for child in grid_container.get_children():
		(child as Control).mouse_entered.connect(func():onMouseEntered(child)) 
		(child as Control).gui_input.connect(func(event): onGUIInput(child, event))

func onMouseEntered(child):
	if dragged_label && child != dragged_label:
		grid_container.move_child(beingMoved, child.get_index())

func onGUIInput(child: Node, event: InputEvent):
	if event is InputEventMouseButton && event.pressed && event.button_index == 1:
		dragged_label = child.duplicate()
		dragged_label.show()
		child.replace_by(Node.new())
		beingMoved = child
	elif event is InputEventMouseButton && !event.pressed && event.button_index == 1:
		beingMoved.replace_by(dragged_label.duplicate())
		for c in grid_container.get_children():
			c.show()
		dragged_label.queue_free()
		

func _process(_delta):
	if dragged_label:
		dragged_label.position = get_global_mouse_position()
