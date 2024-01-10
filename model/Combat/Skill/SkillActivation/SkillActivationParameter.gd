extends Object
class_name SkillActivationParameter

var skillActivationOptimalTargets: SkillActivationOptimalTargets
var activationConditions: Array[SkillActivationConditions]

'''
Boss
opponent
opponent_lowest_health
opponent_highest_danger
opponent_highest_percent_final_damage
opponent if weak to element
opponent if final_damage > health_total / percent_health N
ally lowest health
ally lowest health if health < 50%
ally lowest health if health < N
ally lowest health if missing_health < skillEffectValue
ally_highest_danger if status_effect any
ally if status_effect poison > 50
ally if targeted by projectile danger > N
ally specific ally
activate if target_found
activate if self_buff X > N
activate if skill_cost < mana_percent N
activate if mana_current > mana_percent N / value
activate if buff_not_active X target self
activate if final_damage for target/any target is higher than other skill
Switch to element opponent is weakest to
Overcharge if mana > %/value
Overcharge if base damage not enough to kill, but overcharge is
Overcharge if status
Add target until mana cost limit reached
Add all targets that have/not status effect
Add all targets that dies on final damage

Other type of targetting: Character-wide logic
Find skill with highest final damage for any target/specific target

Activation conditions about activator (has mana, can find target...)
Optimal Target (can be single target and fail if conditions not fullfilled, or target by ranking ie lowest health)
Activation conditions about target (can oneshot, can fullz receive effect, is dead...)
Select parameters of skill activation if possible (overcharge, switch element, add target...)
'''
