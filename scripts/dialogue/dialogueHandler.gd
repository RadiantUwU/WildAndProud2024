extends CanvasGroup
class_name DialogueHandler

var currentDialogueTreeName: String
var currentDialogue: Array[DialogueSection] = []
var currentSection: DialogueSection = null
var currentSectionNumber = -1
var currentLine: DialogueLine = null
var currentLineNumber = -1
var isPrintingOutText = false

@onready var dialogueOptions = [$DialogueOption1, $DialogueOption2, $DialogueOption3, $DialogueOption4]
@onready var speakerSprite = $SpeakerSprite
@onready var speakerNameLabel = $SpeakerName/SpeakerNameLabel
@onready var mainTextLabel = $MainText/MainTextLabel

var justOpened: bool = false

var expectedDialogueOptionsPositions = [
	[],
	[Vector2(-450, -80)],
	[Vector2(-450, -130), Vector2(-450, -30)],
	[Vector2(-450,-140), Vector2(-450, -80), Vector2(-450, -20)],
	[Vector2(-450,-180), Vector2(-450, -120), Vector2(-450, -60), Vector2(-450, 0)]
]

var dialogueSpeakerSpriteCatalogPaths = {
	"willowDialogue1": "res://textures/sprites/willow",	
	"paisleyDialogue1": "res://textures/sprites/paisley",
	"willowDialogue2": "res://textures/sprites/willow",	
	"paisleyDialogue2": "res://textures/sprites/paisley",
	"willowDialogue3": "res://textures/sprites/willow",	
	"paisleyDialogue3": "res://textures/sprites/paisley"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	for option in dialogueOptions:
		option.visible = false
		
# When starting dialogue, pick out correct dialogue tree and start at correct line
func openDialogueBox(dialogueTreeName: String, sectionName: String):
	if(self.visible):
		#cannot open new dialogue box if dialogue box already open
		return
	justOpened = true
	currentDialogueTreeName = dialogueTreeName
	currentDialogue = openJsonAsDialogue(dialogueTreeName)
	currentSectionNumber = -1
	currentLineNumber = -1
	speakerSprite.texture = ResourceLoader.load(dialogueSpeakerSpriteCatalogPaths[dialogueTreeName]+"/default.png")
	self.visible = true
	goToSection(sectionName)
	speakerNameLabel.text = ""
	mainTextLabel.text = ""
	unfurlText()
	
# clear out the dialogue from the box and hide it
func hideDialogueBox():	
	self.currentDialogue = []
	self.currentSection = null
	self.currentLine = null
	unfurlText()
	self.visible = false

func _unhandled_input(event):
	if is_visible():
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			if (event.pressed and !justOpened):			
				if isPrintingOutText:
					printOutText()
					onTextFullyPrintedOut()
				else:
					if len(currentLine.options) <= 0:
						advanceLines()
			else:
				justOpened = false

# trigger once text is fully inside the dialogue box		
func onTextFullyPrintedOut():
	if len (currentLine.options) > 0:
		createDialogueOptions()

# slowly unfurl the text
func unfurlText():
	for option in dialogueOptions:
		option.visible = false
	mainTextLabel.text = "" if currentLine == null else currentLine.line	
	speakerNameLabel.text = "" if currentLine == null else currentLine.name
	if currentLine != null:
		speakerSprite.texture = ResourceLoader.load(dialogueSpeakerSpriteCatalogPaths[currentDialogueTreeName]+"/"+currentLine.emotion+".png")

	createDialogueOptions()

# create clickable boxes containing different dialogue options and place them on the screen in an aesthetic manner
# depending on the amount of options
func createDialogueOptions():
	if currentLine == null:
		return
	if len (currentLine.options) > 0 :
		for i in len(currentLine.options):
			dialogueOptions[i].visible = true
			dialogueOptions[i].get_child(0).text = currentLine.options[i].line
			dialogueOptions[i].position = expectedDialogueOptionsPositions[len(currentLine.options)][i]
				
		
	
# stops slowly unfurling the text and prints it out completely
func printOutText():
	isPrintingOutText = false
		

func _on_dialogue_option_1_pressed():
	onOptionSelection(0)

func _on_dialogue_option_2_pressed():
	onOptionSelection(1)

func _on_dialogue_option_3_pressed():
	onOptionSelection(2)

func _on_dialogue_option_4_pressed():
	onOptionSelection(3)
	
func onOptionSelection(optionIndex):
	if (justOpened):
		justOpened = false
		return
	var selectedOption = currentLine.options[optionIndex]
	if len(selectedOption.onSelection) <= 0:
		advanceLines()
	else:
		handleDialogueEvents(selectedOption.onSelection)
		
func openJsonAsDialogue(dialogueTree: String) -> Array[DialogueSection]:
	var path = "res://resources/dialogue/"+dialogueTree+".json"
	var sections: Array[DialogueSection] = []
	var jsonFile = ResourceLoader.load(path) as JSON
	for rawSection in jsonFile.data:
		var lines: Array[DialogueLine] = []
		for rawLine in rawSection["lines"]:
			var options: Array[DialogueOption] = []
			for rawOption in rawLine["options"]:
				var onSelection: Array[String] = []
				for rawOnSelection in rawOption["onSelection"]:
					onSelection.append(rawOnSelection)
				options.append(DialogueOption.new(rawOption["line"], onSelection))
			lines.append(DialogueLine.new(rawLine["name"], rawLine["line"], rawLine["emotion"], options))
		var onCompletion: Array[String] = []
		for rawOnCompletion in rawSection["onCompletion"]:
			onCompletion.append(rawOnCompletion)
		sections.append(DialogueSection.new(rawSection["section"], lines, onCompletion))
	return sections
		
func advanceSections():
	var found = false
	for i in range(currentSectionNumber + 1, len(currentDialogue)):
		if !found:
			currentSectionNumber = i
			currentSection = currentDialogue[i]
			currentLine = currentSection.lines[0]
			currentLineNumber = 0
			unfurlText()
			found = true
	if !found:
		hideDialogueBox()
			
func advanceLines():
	currentLineNumber += 1
	if len(currentSection.lines) == currentLineNumber:
		if len(currentSection.onCompletion) == 0:
			advanceSections()
		else:
			handleDialogueEvents(currentSection.onCompletion)
	else:
		currentLine = currentSection.lines[currentLineNumber]
		unfurlText()

func handleDialogueEvents(dialogueEvents: Array[String]):
	for event in dialogueEvents:
		var split = event.split(",")
		match split[0]:
			"quit":
				hideDialogueBox()
			"goToSection":
				goToSection(split[1])
			_:
				pass
		
func goToSection(sectionName: String):
	for i in len(currentDialogue):
		if currentDialogue[i].section == sectionName:
			currentSectionNumber = i
			currentSection = currentDialogue[i]
			currentLineNumber = 0			
			currentLine = currentSection.lines[currentLineNumber]
			unfurlText()

func changeEmotion(emotionName: String):
	speakerSprite.texture = ResourceLoader.load(dialogueSpeakerSpriteCatalogPaths[currentDialogueTreeName]+"/"+emotionName+".png")
	
			
