extends Node

class_name GameplayNode

var nextEvent: String
var currentCycle: String

@onready var nightOverlay: CanvasModulate = $NightOverlay
@onready var nextEventTimer: Timer = $NextEventTimer
@onready var dayCycleTimer: Timer = $DayCycleTimer
@onready var gameStageLabel: Label = $GameStageLabel

var nextSections: Dictionary = {
	"Willow1Start": "tea,Willow1",
	"Willow1TeaFinished": "willowDialogue1,Willow1Inquire",
	"Willow1": "paisleyDialogue1,Paisley1Start",
	"Paisley1Start": "tea,Paisley1",
	"Paisley1TeaFinished": "paisleyDialogue1,Paisley1Inquire",
	"Paisley1": "willowDialogue2,Willow2Start",
	
	"Willow2Start": "tea,Willow2",
	"Willow2TeaFinished": "willowDialogue2,Willow2Inquire",
	"Willow2": "paisleyDialogue2,Paisley2Start",
	"Paisley2Start": "tea,Paisley2",
	"Paisley2TeaFinished": "paisleyDialogue2,Paisley2Inquire",
	"Paisley2": "paisleyDialogue3,Paisley3Start",
	
	"Paisley3Start": "tea,Paisley3",
	"Paisley3TeaFinished": "paisleyDialogue3,Paisley3Inquire",
	"Paisley3": "willowDialogue3,Willow3Start",
	"Willow3Start": "tea,Willow3",
	"Willow3TeaFinished": "willowDialogue3,Willow3Inquire",
	"Willow3": "gameOver",
}

# Called when the node enters the scene tree for the first time.
func _ready():
	gameStageLabel.visible = false
	loadSaveFile()	
	DialogueBox.gameplayNode = self

func startCountdown(event: String):
	nextEvent = event
	if event == "Willow1":
		gameStageLabel.text = "You spot a familiar face outside the tea shop..."
		nextEventTimer.start(3)
	elif dayCycleTimer.is_stopped():
		gameStageLabel.text = "You wait for the next customer..."
		nextEventTimer.start(3)
	else:
		if event == "gameOver":
			gameStageLabel.text = "You finished the game! Congratulations!"
			nextEventTimer.start(3)
		else:
			gameStageLabel.text = "You close shop and a new day arrives..."
			nextEventTimer.start(8)
	gameStageLabel.visible = true

func endDay():
	var tween = create_tween()
	tween.tween_property(nightOverlay, "color", Color(0.6,0.4,0.1,1.0), 1.0)
	dayCycleTimer.start(5.0)

func _on_day_cycle_timer_timeout():
	var tween = create_tween()
	var nightOverlayModulate = nightOverlay.modulate
	nightOverlayModulate.a = 0.0
	tween.tween_property(nightOverlay, "color", Color(1.0,1.0,1.0,1.0), 1.0)

func loadSaveFile():
	var completedSections = GameStateHolder.completedSections
	var nextSection = ""
	for sectionKey in nextSections:
		if sectionKey in completedSections:
			nextSection = nextSections[sectionKey]
	if nextSection == "":
		startCountdown("Willow1")
		return
	if nextSection == 'gameOver':
		gameOver()
	else:
		var split = nextSection.split(",")
		if split[0] == 'tea':
			startMakingTea(split[1])
		else:
			DialogueBox.openDialogueBox(split[0], split[1])

func _on_next_event_timer_timeout():
	gameStageLabel.visible = false
	match nextEvent:
		"Willow1":
			DialogueBox.openDialogueBox("willowDialogue1", "Willow1Start")
		"Willow2":
			DialogueBox.openDialogueBox("willowDialogue2", "Willow2Start")
		"Willow3":
			DialogueBox.openDialogueBox("willowDialogue3", "Willow3Start")
		"Paisley1":
			DialogueBox.openDialogueBox("paisleyDialogue1", "Paisley1Start")
		"Paisley2":
			DialogueBox.openDialogueBox("paisleyDialogue2", "Paisley2Start")
		"Paisley3":
			DialogueBox.openDialogueBox("paisleyDialogue3", "Paisley3Start")

func gameOver():
	pass

func startMakingTea(tea: String):
	match(tea):
		"Willow1":			
			gameStageLabel.text = "Make a sweet and very intense tea for Willow"
		"Willow2":			
			gameStageLabel.text = "Make a mild and floral tea for Willow"
		"Willow3":			
			gameStageLabel.text = "Make a mild and herbaceous for Willow"
		"Paisley1":			
			gameStageLabel.text = "Make a mild and slightly herbaceous tea for Paisley"
		"Paisley2":			
			gameStageLabel.text = "Make a very bitter and very intense tea for Paisley"
		"Paisley3":			
			gameStageLabel.text = "Make a sweet and floral tea for Paisley"
	gameStageLabel.visible = true
