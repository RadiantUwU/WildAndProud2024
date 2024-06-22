extends SaveData

class_name GameData

func _init(_fileName: String):
	fileName = _fileName
	saveFile = ConfigFile.new()
