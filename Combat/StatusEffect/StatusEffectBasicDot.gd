extends StatusEffect
class_name StatusEffectBasicDot

func _init():
	super("Basic Dot", 3, 5)

func resolveTrigger(combatantHolder: CombatantInFight, combat: Combat):
	super(combatantHolder, combat)
	currentDelay = 0
	combatantHolder.receiveDamage(self.value)
