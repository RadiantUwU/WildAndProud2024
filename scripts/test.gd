extends Node

class_name GameplayNode

var nextEvent: String
var currentCycle: String
var teaStage = 0
var currentTea = ""

@onready var nightOverlay: CanvasModulate = $NightOverlay
@onready var nextEventTimer: Timer = $NextEventTimer
@onready var dayCycleTimer: Timer = $DayCycleTimer
@onready var gameStageLabel: Label = $GameStageLabel
@onready var teaMakingPanel: TeaMakingPanel = $TeaMakingPanel
@onready var teacup: Sprite2D = $TeaMachine/TeaCup
@onready var waitingCustomerSprite: Sprite2D = $WaitingCustomerSprite

@export var teaStageTexture: Array[Texture2D]
@export var waitingCustomerTextures: Array[Texture2D]

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
	teaMakingPanel.gameplayNode = self
	teaMakingPanel.visible = false
	restartTeaStage()

func startCountdown(event: String):
	waitingCustomerSprite.visible = false
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
		"gameOver":
			gameOver()

func gameOver():
	DialogueBox.hideDialogueBox()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func presentTea(tea: Tea):
	teaMakingPanel.deactivate()
	gameStageLabel.visible = false
	if currentTea == "Willow1":
		if tea.sweetness == 3 and tea.flavor == 5:
			if "Willow1TeaFailure" in GameStateHolder.completedSections:
				DialogueBox.openDialogueBox("willowDialogue1", "Willow1TeaSuccess")
			else:
				DialogueBox.openDialogueBox("willowDialogue1", "Willow1TeaFlawless")
		else:
			DialogueBox.openDialogueBox("willowDialogue1", "Willow1TeaFailure")
	if currentTea == "Paisley1":
		if tea.flavor == 1 and tea.herbaceousness == 1:
			if "Paisley1TeaFailure" in GameStateHolder.completedSections:
				DialogueBox.openDialogueBox("paisleyDialogue1", "Paisley1TeaSuccess")
			else:
				DialogueBox.openDialogueBox("paisleyDialogue1", "Paisley1TeaFlawless")
		else:
			DialogueBox.openDialogueBox("paisleyDialogue1", "Paisley1TeaFailure")
			
	if currentTea == "Willow2":
		if tea.herbaceousness == -3 and tea.flavor == -4:
			if "Willow2TeaFailure" in GameStateHolder.completedSections:
				DialogueBox.openDialogueBox("willowDialogue2", "Willow2TeaSuccess")
			else:
				DialogueBox.openDialogueBox("willowDialogue2", "Willow2TeaFlawless")
		else:
			DialogueBox.openDialogueBox("willowDialogue2", "Willow2TeaFailure")
	if currentTea == "Paisley2":
		if tea.flavor == 5 and tea.sweetness == -5:
			if "Paisley2TeaFailure" in GameStateHolder.completedSections:
				DialogueBox.openDialogueBox("paisleyDialogue2", "Paisley2TeaSuccess")
			else:
				DialogueBox.openDialogueBox("paisleyDialogue2", "Paisley2TeaFlawless")
		else:
			DialogueBox.openDialogueBox("paisleyDialogue2", "Paisley2TeaFailure")
			
			
	if currentTea == "Willow3":
		if tea.sweetness == 1 and tea.herbaceousness == 3:
			if "Willow3TeaFailure" in GameStateHolder.completedSections:
				DialogueBox.openDialogueBox("willowDialogue3", "Willow3TeaSuccess")
			else:
				DialogueBox.openDialogueBox("willowDialogue3", "Willow3TeaFlawless")
		else:
			DialogueBox.openDialogueBox("willowDialogue3", "Willow3TeaFailure")
	if currentTea == "Paisley3":
		if tea.sweetness == 3 and tea.herbaceousness == -3:
			if "Paisley3TeaFailure" in GameStateHolder.completedSections:
				DialogueBox.openDialogueBox("paisleyDialogue3", "Paisley3TeaSuccess")
			else:
				DialogueBox.openDialogueBox("paisleyDialogue3", "Paisley3TeaFlawless")
		else:
			DialogueBox.openDialogueBox("paisleyDialogue3", "Paisley3TeaFailure")
				
					
			

func startMakingTea(tea: String):
	currentTea = tea
	match(tea):
		"Willow1":
			gameStageLabel.text = "Make a sweet and very intense tea for Willow"
		"Willow2":
			gameStageLabel.text = "Make a floral and pretty mild tea for Willow"
		"Willow3":
			gameStageLabel.text = "Make an herbaceous and somewhat sweet tea for Willow"
		"Paisley1":
			gameStageLabel.text = "Make a slightly strong and slightly herbaceous tea for Paisley"
		"Paisley2":
			gameStageLabel.text = "Make a very bitter and very intense tea for Paisley"
		"Paisley3":
			gameStageLabel.text = "Make a sweet and floral tea for Paisley"
	
	if tea.contains("Willow"):
		waitingCustomerSprite.texture = waitingCustomerTextures[0]
	elif tea.contains("Paisley"):
		waitingCustomerSprite.texture = waitingCustomerTextures[1]
	waitingCustomerSprite.visible = true
	
	gameStageLabel.visible = true	
	teaMakingPanel.activate()

func _on_green_tea_button_pressed():
	teaMakingPanel.addIngredient(Tea.GREEN_TEA)

func _on_white_tea_button_pressed():
	teaMakingPanel.addIngredient(Tea.WHITE_TEA)

func _on_black_tea_pressed():
	teaMakingPanel.addIngredient(Tea.BLACK_TEA)

func _on_chai_tea_button_pressed():
	teaMakingPanel.addIngredient(Tea.CHAI_TEA)

func _on_rooibos_tea_pressed():
	teaMakingPanel.addIngredient(Tea.ROOIBOS_TEA)

func _on_cinnamon_button_pressed():
	teaMakingPanel.addIngredient(Tea.CINNAMON)

func _on_milk_button_pressed():
	teaMakingPanel.addIngredient(Tea.MILK)

func _on_jasmine_button_pressed():
	teaMakingPanel.addIngredient(Tea.JASMINE)

func _on_mint_button_pressed():
	teaMakingPanel.addIngredient(Tea.MINT)
	
func advanceTeaStage():
	teaStage += 1
	teacup.texture = teaStageTexture[teaStage]
	
func restartTeaStage():
	teaStage = 0
	teacup.texture = teaStageTexture[teaStage]

func _on_restart_pressed():
	DialogueBox.hideDialogueBox()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
