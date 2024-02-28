extends Object
class_name SavesHelper

const lastVersion = 0.1
enum PayloadType{
	PLAYER_DATA, COMBAT_MANAGER
}
static var s2c_payloads := { 
		 PayloadType.PLAYER_DATA: PlayerData,
		 PayloadType.COMBAT_MANAGER: CombatManager,
}

#TODO
func updateVersion(currentVersion, latestVersion = lastVersion):
	pass

static func save_game():
	var saveObject = makeSaveObject()
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	save_game.store_line(saveObject)

static func loadGame():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	var fileAccess = FileAccess.open("user://savegame.save", FileAccess.READ)
	var line = fileAccess.get_line()
	var save_game = JSON.parse_string(line)
	var pDataLine = save_game["combatData"]
	PlayerData.instance = deserialize(save_game["playerdata"])
	var dCombat = deserialize(save_game["combatData"])
	CombatManager.instance = deserialize(save_game["combatData"])
	var esoif = CombatManager.instance
	print("Save time: " + str(save_game["currentTimeinSeconds"]) + ", current time: " + str(Time.get_unix_time_from_system()))

static func makeSaveObject():
	var combatData = serializeObject(CombatManager.getInstance())
	var playerData = serializeObject(PlayerData.getInstance())
	var currentTimeinSeconds = Time.get_unix_time_from_system()
	var gameVersion = lastVersion
	var saveFileData := {"playerdata": JSON.stringify(playerData), \
	"combatData": JSON.stringify(combatData), \
	"currentTimeinSeconds": currentTimeinSeconds, \
	"gameVersion": gameVersion}
	return JSON.stringify(saveFileData)

static func serializeObject(objectToSerialize: Object):
	var payload = recursively_serialize_object(objectToSerialize)
	var type
	if is_instance_of(objectToSerialize, CombatManager):
		type = PayloadType.COMBAT_MANAGER
	elif is_instance_of(objectToSerialize, PlayerData):
		type = PayloadType.PLAYER_DATA
	return {"type": type, "payload": payload}
	
#https://github.com/godotengine/godot/issues/70720#issuecomment-1677752280
static func recursively_serialize_object(instance: Object) -> Dictionary:
	var dict := inst_to_dict(instance)

	for key in dict:
		var field = dict[key]
		
		if is_instance_of(field, Object):
			dict[key] = recursively_serialize_object(field)
		elif field is Array:
			var new_array := []
			for entry in field:
				if is_instance_of(entry, Object):
					new_array.append(recursively_serialize_object(entry))
				else:
					new_array.append(entry)
			dict[key] = new_array
			pass
		elif field is Dictionary:
			var new_dictionary := {}
			for fKey in field.keys():
				var serializedKey
				var serializedValue
				if is_instance_of(fKey, Object):
					serializedKey = recursively_serialize_object(fKey)
				else:
					serializedKey = fKey
				if is_instance_of(field[fKey], Object):
					serializedKey = recursively_serialize_object(field[fKey])
				else:
					serializedKey = field[fKey]
				new_dictionary[serializedKey] = serializedValue
			dict[key] = new_dictionary
		# else keep value
	if !dict.has("scriptType"):
		var sf = instance.get_script().resource_path.get_file() 
		dict["scriptType"] = sf
	return dict

static func deserialize(message: String): 
	var packet: Dictionary = JSON.parse_string(message) 

	var type: int = packet.get("type") 
	var payload_dict: Dictionary = packet.get("payload") 

	var payload_script = s2c_payloads.get(type) 

	assert(payload_script != null, "Payload type %s is not defined, run exporter" % type) 

	var payload = payload_script.new() 
	_assign_object_values(payload, payload_dict) 

	return payload 
  
  
 # object is filled with values from the dictionary 
static func _assign_object_values(object, dict: Dictionary) -> void: 
	for dict_key in dict: 
	# We get the field from the object to know its type/script 
		var object_field = object.get(dict_key) 
		if object_field is Array: 
			var script = object_field.get_typed_script() 
			if script == null: 
				# Array is untyped or of a built-in type. Assuming the array 
				# items don't need to be deserialized
				object.set(dict_key, dict.get(dict_key)) 
			else: 
				# Construct a new entry and add it to the object's existing array 
				for array_entry in dict.get(dict_key): 
					var instance = script.new() 
					_assign_object_values(instance, array_entry) 
					object.get(dict_key).append(instance) 
		elif object_field is Object: 
			var instance = object_field.new() 
			_assign_object_values(instance, dict.get(dict_key)) 
			object.set(dict_key, instance) 
		elif object_field is Dictionary:
			var deserializedDic := {}
			_assign_object_values(deserializedDic, object_field)
			object.set(dict_key, deserializedDic)
		else: 
			# Should be a built-in type, so set what we got from parsing json 
			if object is Dictionary:
				object[dict_key] = dict.get(dict_key)
			else:
				object.set(dict_key, dict.get(dict_key))
