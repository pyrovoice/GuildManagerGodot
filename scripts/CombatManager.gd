extends Node


var c1 = Combatant.new("Hero", 500, 100, 12)
# Called when the node enters the scene tree for the first time.
func _ready():
	var d1 = preload("res://objects/combatant_display_combat.tscn").instantiate()
	d1.init(c1)
	self.add_child(d1)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.c1.healthCurrent = self.c1.healthCurrent - 0.1
	pass
