extends Object
class_name CombatPositionsCombatant

enum ROW{
	FRONT_ROW,
	BACK_ROW
}
#<CombatantInFight, Vector2>
var playerCombatants: Array[CombatantInFight] = []
var opponentCombatants: Array[CombatantInFight] = []
var locationSize: Vector2

func _init(_locationSize: Vector2, playerCombatantsFront: Array[CombatantInFight] = [], playerCombatantsBack: Array[CombatantInFight] = []):
	locationSize = _locationSize
	for c in playerCombatantsFront:
		if c != null:
			var x = playerCombatantsFront.find(c)
			addCombatantAtLocation(c, Vector2(playerCombatantsFront.find(c), ROW.FRONT_ROW), true)
	for c in playerCombatantsBack:
		if c != null:
			var x = playerCombatantsBack.find(c)
			addCombatantAtLocation(c, Vector2(playerCombatantsBack.find(c), ROW.BACK_ROW), true)

func addCombatantAtLocation(combatant: CombatantInFight, location: Vector2, isAlly: bool):
	var arrayToLookAt = playerCombatants if isAlly else opponentCombatants
	if !isLocationEmptyAndInRange(location, arrayToLookAt):
		location = getFirstEmptyLocation(arrayToLookAt, -1)
	if combatant && isLocationEmptyAndInRange(location, arrayToLookAt):
		combatant.position = location
		arrayToLookAt.push_back(combatant)
		
func moveCombatantToLocation(combatant: CombatantInFight, location: Vector2, side: Array):
	if !isLocationEmptyAndInRange(location, side):
		return
	combatant.setPosition(location)

func moveCombatantSwitchRow(combatant: CombatantInFight):
	var side = getTeamOfCombatant(combatant)
	var otherRow = ROW.FRONT_ROW if combatant.position.y == ROW.BACK_ROW else ROW.BACK_ROW
	var emptyLocationCoordinate = getFirstEmptyLocation(side, otherRow)
	if emptyLocationCoordinate == Vector2(-1, -1):
		return
	combatant.setPosition(emptyLocationCoordinate)
	
func isLocationEmptyAndInRange(location: Vector2, side: Array):
	if location.x < 0 || location.y <0 || location.x > locationSize.x || location.y > locationSize.y:
		return false
	if side.filter(func(c: CombatantInFight): return c.position == location).size() != 0:
		return false
	return true

func getFirstEmptyLocation(side: Array, row: int) -> Vector2:
	if row == ROW.FRONT_ROW || row != ROW.BACK_ROW:
		for i in range(0, getSlotPerRowLocation()):
			if isLocationEmptyAndInRange(Vector2(i, ROW.FRONT_ROW), side):
				return Vector2(i, ROW.FRONT_ROW)
	if row == ROW.BACK_ROW || row != ROW.FRONT_ROW:
		for i in range(0, getSlotPerRowLocation()):
			if isLocationEmptyAndInRange(Vector2(i, ROW.BACK_ROW), side):
				return Vector2(i, ROW.BACK_ROW)
	return Vector2(-1, -1)
		
func getSlotPerRowLocation():
	return locationSize.x
	
func getNumberRowLocation():
	return locationSize.y

func getDistanceBetweenTwoCombatants(source: CombatantInFight, target: CombatantInFight):
	if getTeamOfCombatant(source).find(target) != -1:
		return abs(source.position.y - target.position.y)
	var effectiveYSource = ROW.FRONT_ROW if source.position.y == ROW.FRONT_ROW || getCombatantsInRow(getTeamOfCombatant(source), true).filter(func(c): return c.isAlive()).size() == 0 else ROW.BACK_ROW
	var effectiveYTarget = ROW.FRONT_ROW if target.position.y == ROW.FRONT_ROW || getCombatantsInRow(getTeamOfCombatant(target), true).filter(func(c): return c.isAlive()).size() == 0 else ROW.BACK_ROW
	return effectiveYSource + effectiveYTarget + 1
	
func getTeamOfCombatant(source: CombatantInFight) -> Array:
	if playerCombatants.find(source) != -1:
		return playerCombatants
	elif opponentCombatants.find(source) != -1:
		return opponentCombatants
	printerr("Cannot find team of combatant: " + source.name)
	return []
	
func getOpponentsOfCombatant(source: CombatantInFight) -> Array:
	if playerCombatants.find(source) != -1:
		return opponentCombatants
	elif opponentCombatants.find(source) != -1:
		return playerCombatants
	printerr("Cannot find opponents of combatant: " + source.name)
	return []
	
func getTeam(allyTeam: bool) -> Array:
	return playerCombatants if allyTeam else opponentCombatants
	
func getCombatantsInRow(container: Array, isFront: bool) -> Array:
	var row = ROW.FRONT_ROW if isFront else ROW.BACK_ROW
	return container.filter(func(c): return c.position.y == row)
