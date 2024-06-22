extends CanvasGroup

class_name SettingsMenu

var mainMenu: MainMenu

@onready var settingsMenuPanel: SettingsMenuPanel = $SettingsMenuPanel

# Called when the node enters the scene tree for the first time.
func _ready():
	settingsMenuPanel.settingsMenu = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func onReturnPressed():
	mainMenu.switchByName("welcome")
