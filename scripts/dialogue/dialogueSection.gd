class_name DialogueSection

var section: String
var lines: Array[DialogueLine]
var onCompletion: Array[String]

func _init(_section: String, _lines: Array[DialogueLine], _onCompletion: Array[String]):
	self.section = _section
	self.lines = _lines
	self.onCompletion = _onCompletion
