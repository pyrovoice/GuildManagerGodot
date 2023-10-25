extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var c = preload("res://objects/combatantModificationDisplay.tscn").instantiate()
	self.add_child(c)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
