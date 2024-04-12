extends Node
class_name CombatantDisplay

@onready var health_bar = $HealthBar
@onready var health = $HealthBar/Health
@onready var mana_bar = $ManaBar
@onready var mana = $ManaBar/Mana
@onready var action_bar = $ActionBar
@onready var status_effect_button: ColorRect = $status_effect_button
@onready var status_effect_tooltip:ColorRect = $status_effect_button/ColorRect
@onready var status_effect_text = $status_effect_button/ColorRect/Label

var combatant: CombatantInFight = null
func init(c: CombatantInFight):
	self.combatant = c
	status_effect_text.text = ""
	status_effect_button.mouse_entered.connect(func(): status_effect_tooltip.show())
	status_effect_button.mouse_exited.connect(func(): status_effect_tooltip.hide())
	updateDisplay()

func _process(_delta):
	updateDisplay()
	
func updateDisplay():
	if self.combatant != null && health:
		health.text = floatToSnapText(self.combatant.healthCurrent) + "/" + floatToSnapText(self.combatant.getAttribute(CombatAttributeEnum.att.HEALTH))
		mana.text = floatToSnapText(self.combatant.manaCurrent) + "/" + floatToSnapText(self.combatant.getAttribute(CombatAttributeEnum.att.MANA))
		get_node("Name").text = self.combatant.name
		health_bar.max_value = self.combatant.getAttribute(CombatAttributeEnum.att.HEALTH)
		health_bar.value = self.combatant.healthCurrent
		mana_bar.max_value = self.combatant.getAttribute(CombatAttributeEnum.att.MANA)
		mana_bar.value = self.combatant.manaCurrent
		get_node("ActionBar").max_value = self.combatant.delayToAct
		get_node("ActionBar").value = self.combatant.actionCooldown
		get_node("Attack").text = str(self.combatant.getAttribute(CombatAttributeEnum.att.STRENGTH))
		if combatant.statusEffects.size() > 0:
			status_effect_button.show()
			var seText = ""
			for se in combatant.statusEffects:
				seText += se.name + " "
				seText += floatToSnapText(se.getText()) + "\n"
			status_effect_text.text = seText
		else:
			status_effect_button.hide()

func floatToSnapText(f: float) -> String:
	return str(snapped(f, 0.1))
