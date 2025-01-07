extends Control

@onready var delete_combat = $DeleteCombat
@onready var location_name = $LocationName
@onready var ennemies_front = $Ennemies/VBoxContainer/EnnemiesFront
@onready var ennemies_back = $Ennemies/VBoxContainer/EnnemiesBack
@onready var allies_front = $Allies/VBoxContainer/AlliesFront
@onready var allies_back = $Allies/VBoxContainer/AlliesBack

const ATTACK_PROJECTILE = preload("res://Assets/textures/attack_projectile.tscn")
const COMBATANT_DISPLAY_COMBAT = preload("uid://ccfjcmib782th")
const COMBATANT_DISPLAY_EMPTY = preload("res://Assets/textures/CombatantDisplayEmpty.tscn")

var animationQueue: Array = []
class CombatDisplayUpdate:
	var skill: ActivatedSkillData
	var combatState: Combat
	func _init(_skill, _combatState):
		skill = _skill
		combatState = _combatState
	
var currentTween: Tween
signal removeCombat

var combat: Combat = null
func init(co :Combat):
	if co:
		self.combat = co
		combat.combatantsChange.connect(updateCombatants)
		combat.on_combat_action.connect(addToAnimationQueue)
		updateCombatants()

func _process(delta):
	if currentTween && currentTween.is_running():
		pass
	elif !animationQueue.is_empty():
		playNextAnimation()
	else:
		updateCombatantDisplay(combat)

func playNextAnimation():
	if animationQueue && animationQueue.size() > 0:
		animateCombatAction(animationQueue[0])
	
func addToAnimationQueue(skill: ActivatedSkillData, combatState: Combat):
	animationQueue.push_back(CombatDisplayUpdate.new(skill, combatState))
	
func animateCombatAction(data: CombatDisplayUpdate):
	var skill:ActivatedSkillData = data.skill
	for fragment: SkillLogFragment in skill.skillLog.fragments:
		if fragment.effectSource.effectType == EffectDecriptorType.e.DAMAGE:
			if fragment.effectSource.range == 1:
				animateMeleeAttack(skill.activator, fragment.effectReceiver, fragment.value)
	updateCombatantDisplay(data.combatState)
	animationQueue.remove_at(0)

func animateMeleeAttack(source, target, value):
	var sourceDisplay = getCombatantDisplay(source)
	var targetDisplay = getCombatantDisplay(target)
	if !sourceDisplay || !targetDisplay:
		return
	currentTween = get_tree().create_tween()
	currentTween.tween_property(sourceDisplay.get_child(0), "global_position", targetDisplay.global_position, 0.4)
	currentTween.finished.connect(func():
		currentTween = get_tree().create_tween()
		currentTween.tween_property(sourceDisplay.get_child(0), "position", Vector2(0, 0), 0.4)
		currentTween.finished.connect(playNextAnimation)
		)

func updateCombatants():
	location_name.text = combat.location.name + " " + str(combat.level) + " - " + str(combat.encounterCounter) + "/" + str(combat.location.encounterPerLevel)
	for c in ennemies_front.get_children():
		ennemies_front.remove_child(c)
	for c in ennemies_back.get_children():
		ennemies_back.remove_child(c)
	for c in allies_front.get_children():
		allies_front.remove_child(c)
	for c in allies_back.get_children():
		allies_back.remove_child(c)
	for y in combat.combatants.getNumberRowLocation():
		for x in combat.combatants.getSlotPerRowLocation():
			addCombatantOrEmptySlot(Vector2(x, y), true)
			addCombatantOrEmptySlot(Vector2(x, y), false)
	
func addCombatantOrEmptySlot(combatantLocation: Vector2, isAlly: bool):
	var display = COMBATANT_DISPLAY_EMPTY.instantiate()
	var combatantAtLocation = combat.combatants.getTeam(isAlly).filter(func(c): return c.position == combatantLocation)
	if combatantAtLocation.size() == 1:
		display = COMBATANT_DISPLAY_COMBAT.instantiate()
		display.init(combatantAtLocation[0])
	var container: GridContainer
	if isAlly:
		container = allies_front if combatantLocation.y == combat.combatants.ROW.FRONT_ROW else allies_back
	else:
		container = ennemies_front if combatantLocation.y == combat.combatants.ROW.FRONT_ROW else ennemies_back
	container.add_child(display)

func _on_delete_combat_pressed():
	removeCombat.emit()

func getCombatantDisplay(combatant) -> CombatantDisplay:
	for display in ennemies_front.get_children():
		if display is CombatantDisplay && display.combatant == combatant:
			return display
	for display in ennemies_back.get_children():
		if display is CombatantDisplay && display.combatant == combatant:
			return display
	for display in allies_front.get_children():
		if display is CombatantDisplay && display.combatant == combatant:
			return display
	for display in allies_back.get_children():
		if display is CombatantDisplay && display.combatant == combatant:
			return display
	return null

func updateCombatantDisplay(combatState: Combat):
	updateCombatants()
	for c in combatState.getCombatants():
		getCombatantDisplay(c).updateDisplayState(c)
