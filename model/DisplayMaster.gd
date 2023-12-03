extends Control

var showNodes: Array[String] = []
# Called when the node enters the scene tree for the first time.
func _ready():
	var cWindow = self.get_node("ChildWindow")
	for n in cWindow.get_children():
		self.showNodes.push_back(n.get_name())
	self.get_node("Locations").pressed.connect(func(): self.showNode(0))
	self.get_node("Data").pressed.connect(func(): self.showNode(1))
	self.get_node("Heros").pressed.connect(func(): self.showNode(2))
	self.get_node("Equipement").pressed.connect(func(): self.showNode(3))
	self.get_node("Manage").pressed.connect(func(): self.showNode(4))
	showNode(0)

func _process(delta):
	GameMaster.getInstance().process(delta)

func showNode(index):
	var cWindow = self.get_node("ChildWindow")
	for s in showNodes:
		cWindow.get_node(s).hide()
	if cWindow.get_node(showNodes[index]).has_method("init"):
		cWindow.get_node(showNodes[index]).init()
	cWindow.get_node(showNodes[index]).show()
