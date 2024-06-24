extends Node

class_name TeaMakingPanel

var tea: Tea = Tea.new()
@onready var warning: Label = $Warning
@onready var instructions: Label = $Instructions
@onready var warningDisplayTimer: Timer = $WarningDisplayTimer
@onready var confirmButton: TextureButton = $Confirm

@onready var flavorSlider: Slider = $Flavor/FlavorSlider
@onready var sweetnessSlider: Slider = $Sweetness/SweetnessSlider
@onready var herbaceousnessSlider: Slider = $Herbaceousness/HerbaceousnessSlider

@onready var flavorValue: Label = $Flavor/FlavorValue
@onready var sweetnessValue: Label = $Sweetness/SweetnessValue
@onready var herbaceousnessValue: Label = $Herbaceousness/HerbaceousnessValue

var gameplayNode: GameplayNode

func activate():
	self.visible = true
	_on_restart_pressed()
	confirmButton.visible = false
	
func deactivate():
	self.visible = false
	
func addIngredient(ingredient: Dictionary):
	if !self.visible:
		return
	warning.visible = false
	if tea.add_to_tea_mix(ingredient):
		
		flavorSlider.value = tea.flavor
		flavorValue.text = str(tea.flavor)
		sweetnessSlider.value = tea.sweetness
		sweetnessValue.text = str(tea.sweetness)
		herbaceousnessSlider.value = tea.herbaceousness
		herbaceousnessValue.text = str(tea.herbaceousness)
		gameplayNode.advanceTeaStage()
		
		if tea.currentAdditivesAmount == 1 and tea.currentTeaBasesAmount == 2:
			instructions.text = "Present the tea to your customer, or restart the brewing process."
			confirmButton.visible = true
		pass
	else:
		warning.visible = true
		warningDisplayTimer.start(5)
		if tea.currentAdditivesAmount < 1:
			warning.text = "You can't add any more tea packets!"
		elif tea.currentTeaBasesAmount < 2:
			warning.text = "You can't add any more additives!"
		else:
			warning.text = "You can't add any more ingredients!"

func _on_warning_display_timer_timeout():
	warning.visible = false

func _on_confirm_pressed():
	gameplayNode.restartTeaStage()
	gameplayNode.presentTea(self.tea)

func _on_restart_pressed():
	instructions.text = "Mix together 2 packets of tea and 1 extra ingredient from the machine to balance the flavor profile."
	tea.restart_brewing()
	confirmButton.visible = false
	gameplayNode.restartTeaStage()
			
	flavorSlider.value = tea.flavor
	flavorValue.text = str(tea.flavor)
	sweetnessSlider.value = tea.sweetness
	sweetnessValue.text = str(tea.sweetness)
	herbaceousnessSlider.value = tea.herbaceousness
	herbaceousnessValue.text = str(tea.herbaceousness)
