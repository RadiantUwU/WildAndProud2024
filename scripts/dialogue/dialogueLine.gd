class_name DialogueLine

var name: String
var line: String
var options: Array[DialogueOption]

func _init(_name: String, _line: String, _options: Array[DialogueOption]):
	self.name = _name
	self.line = _line
	self.options = _options
