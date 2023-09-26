extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var c = preload("res://objects/combat.tscn").instantiate()
	self.add_child(c)
	c.init()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
