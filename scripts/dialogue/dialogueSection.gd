class_name DialogueSection

var section: String
var condition: bool
var lines: Array[DialogueLine]

func _init(_section: String, _condition: bool, _lines: Array[DialogueLine]):
	self.section = _section
	self.condition = _condition
	self.lines = _lines
