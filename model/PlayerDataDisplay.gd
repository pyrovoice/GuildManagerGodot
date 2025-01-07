extends Control

@onready var button: Button = $Button
@onready var wood: Label = $wood
@onready var button_2 = $Button2
@onready var gold: Label = $gold

# Called when the node enters the scene tree for the first time.
func _ready():
	button.pressed.connect(func():
		PlayerData.getInstance().addResource("wood", 1)
		)
	button_2.pressed.connect(func():
		PlayerData.getInstance().addGold(1) 
		)
	PlayerData.getInstance().on_resource_updated.connect(func():
		wood.text = str(PlayerData.getInstance().playerResource.getResourceValue("wood"))
		gold.text = str(PlayerData.getInstance().gold)
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	get_child(0).text = str(PlayerData.getInstance().gold)
	pass
