class_name SaveData

var fileName: String = ""
var saveFile: ConfigFile
var data: Dictionary = {}

#loads file and puts stuff inside the dictionary
func loadFile():
	var err = saveFile.load("user://"+fileName+".cfg")
	if err == OK:
		var entryKeys = saveFile.get_value(fileName, "entry_keys", [])
		for entry in entryKeys:
			data[entry] = saveFile.get_value(fileName, entry, null)

#saves data into the file
func save():
	for key in data.keys():
		saveFile.set_value(fileName, key, data[key])
	if (len(data.keys()) > 0):
		saveFile.set_value(fileName, "entry_keys", data.keys())
	saveFile.save("user://"+fileName+".cfg")

#adds new entry to save data and auto-saves
func setOrPut(key: String, value: Variant):
	data[key] = value
	save()
	
# Use this function to safely retrieve any value from the save file.
# Supply a default value in case info cannot be found.
func safeGet(key: String, defaultValue: Variant) -> Variant:
	return data.get(key, defaultValue)

# clears the entire file
func clear():
	data.clear()
	save()

#replaces contents of saveData with a separate dictionary
func overwrite(newData: Dictionary):
	data = newData
	save()
