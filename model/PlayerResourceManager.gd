extends Resource
class_name PlayerResourceManager

var resources: Array[GameResource] = []

func getResource(name):
	var find: Array = resources.filter(func(v:GameResource): return v.name == name)
	if find && find.size() > 0:
		return find[0]
	return null

func getResourceValue(name):
	var r: GameResource = getResource(name)
	if r:
		return r.quantity
	return 0
