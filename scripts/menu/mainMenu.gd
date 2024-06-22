extends Node

class_name MainMenu

var activeMenu: CanvasGroup = null

@onready var welcomeMenu: WelcomeScreen = $WelcomeScreen
@onready var playMenu: CanvasGroup = $PlayScreen
@onready var settingsMenu: SettingsMenu = $SettingsScreen
@onready var creditsMenu: CanvasGroup = $CreditsScreen
# Called when the node enters the scene tree for the first time.
func _ready():
	switch(welcomeMenu)
	welcomeMenu.mainMenu = self
	settingsMenu.mainMenu = self


func switch(newMenu: CanvasGroup):
	if (activeMenu != null):
		activeMenu.visible = false
	activeMenu = newMenu
	activeMenu.visible = true

func switchByName(menuName: String):
	match menuName:
		"welcome":
			switch(welcomeMenu)
		"play":
			switch(playMenu)
		"settings":
			switch(settingsMenu)
		"credits":
			switch(creditsMenu)
