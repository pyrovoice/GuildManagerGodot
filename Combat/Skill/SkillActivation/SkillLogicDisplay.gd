extends Control

var combatant: Combatant
var selectedSkill: Skill
const combatantDisplaySmall = preload("res://scenes/CombatantDisplaySmall.tscn")
@onready var combatant_display_small = $CombatantDisplaySmall
@onready var activationConditionContainer = $MarginContainer/GridContainer
@onready var preferedTargetContainer = $MarginContainer2/GridContainer
@onready var targetConditionContainer = $MarginContainer3/GridContainer

func init(_combatant):
	self._combatant = _combatant
	combatant_display_small.init(combatant)
	selectedSkill = combatant.skills[0]
