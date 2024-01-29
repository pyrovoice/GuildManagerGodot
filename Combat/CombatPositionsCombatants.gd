extends Object
class_name CombatPositionsCombatant

const FRONT_ROW = 0
const BACK_ROW = 1
#<CombatantInFight, Vector2>
var playerCombatants: Dictionary = {}
var opponentCombatants: Dictionary = {}
var locationSize: Vector2

func _init(_locationSize: Vector2, playerCombatantsFront: Array[Combatant], playerCombatantsBack: Array[Combatant] ):
	locationSize = _locationSize
	for c in playerCombatantsFront:
		if c != null:
			var x = playerCombatantsFront.find(c)
			addCombatantAtLocation(Vector2(playerCombatantsFront.find(c), FRONT_ROW), c, true)
	for c in playerCombatantsBack:
		if c != null:
			var x = playerCombatantsBack.find(c)
			addCombatantAtLocation(Vector2(playerCombatantsBack.find(c), BACK_ROW), c, true)

func addCombatantAtLocation(location: Vector2, combatant: Combatant, isAlly: bool):
	var dictionnaryToLookAt = playerCombatants if isAlly else opponentCombatants
	if location == Vector2(-1, -1):
		location = getFirstEmptyLocation(dictionnaryToLookAt, -1)
	if combatant && isLocationEmptyAndInRange(location, dictionnaryToLookAt):
		dictionnaryToLookAt[CombatantInFight.new(combatant)] = location
		
func moveCombatantToLocation(combatant: CombatantInFight, location: Vector2, side: Dictionary):
	if !isLocationEmptyAndInRange(location, side):
		return
	side[combatant] = location

func moveCombatantSwitchRow(combatant: CombatantInFight, side: Dictionary):
	var otherRow = FRONT_ROW if side[combatant].y == BACK_ROW else BACK_ROW
	var emptyLocationCoordinate = getFirstEmptyLocation(side, otherRow)
	if emptyLocationCoordinate == Vector2(-1, -1):
		return
	side[combatant] = emptyLocationCoordinate
	
func isLocationEmptyAndInRange(location: Vector2, side: Dictionary):
	if location.x > locationSize.x || location.y > locationSize.y:
		return false
	if side.values().find(location) != -1:
		return false
	return true

func getFirstEmptyLocation(side: Dictionary, row: int) -> Vector2:
	if row == FRONT_ROW || row != BACK_ROW:
		for i in range(0, getSlotPerRowLocation()):
			if side.values().find(Vector2(i, FRONT_ROW)) == -1:
				return Vector2(i, FRONT_ROW)
	if row == BACK_ROW || row != FRONT_ROW:
		for i in range(0, getSlotPerRowLocation()):
			if side.values().find(Vector2(i, BACK_ROW)) == -1:
				return Vector2(i, BACK_ROW)
	return Vector2(-1, -1)
		
func getSlotPerRowLocation():
	return locationSize.x
	
func getNumberRowLocation():
	return locationSize.y

func getDistanceBetweenTwoCombatants(source: CombatantInFight, target: CombatantInFight):
	var vectorSource = getCombatantLocation(source)
	var vectorTarget = getCombatantLocation(target)
	if getTeamOfCombatant(source).values().find(target) != -1:
		return abs(vectorSource.y - vectorTarget.y)
	var effectiveYSource = FRONT_ROW if vectorSource.y == FRONT_ROW || getCombatantsInRow(getTeamOfCombatant(source), true).filter(func(c): return c.isAlive()).size() == 0 else BACK_ROW
	var effectiveYTarget = FRONT_ROW if vectorTarget.y == FRONT_ROW || getCombatantsInRow(getTeamOfCombatant(target), true).filter(func(c): return c.isAlive()).size() == 0 else BACK_ROW
	return effectiveYSource + effectiveYTarget + 1
	
func getCombatantLocation(source: CombatantInFight) -> Vector2:
	if playerCombatants.get(source) != null:
		return playerCombatants.get(source)
	elif opponentCombatants.get(source) != null:
		return opponentCombatants.get(source)
	return Vector2(-1, -1)
	
func getTeamOfCombatant(source: CombatantInFight):
	if playerCombatants.get(source) != null:
		return playerCombatants
	elif opponentCombatants.get(source) != null:
		return opponentCombatants
	
func getOpponentsOfCombatant(source: CombatantInFight):
	if playerCombatants.get(source) != null:
		return opponentCombatants
	elif opponentCombatants.get(source) != null:
		return playerCombatants
	
func getTeam(allyTeam: bool):
	return playerCombatants if allyTeam else opponentCombatants
	
func getCombatantsInRow(container: Dictionary, isFront: bool):
	var row = FRONT_ROW if isFront else BACK_ROW
	return container.keys().filter(func(c): return container[c].y == row)
