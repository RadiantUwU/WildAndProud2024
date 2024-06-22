class_name DialogueOption

var line: String
var onSelection: Array[String]

func _init(_line: String, _onSelection: Array[String]):
	self.line = _line
	self.onSelection = _onSelection
