extends Node

class_name SaveLoader

static var gameData: GameData
static var settingsData = SettingsData.new()

func _ready():
	settingsData.loadFile()
	loadSaveFile()

#use to load saveFile
func loadSaveFile():
	gameData = GameData.new("savefile_0")
	gameData.loadFile()
	GameStateHolder.initGameState()

#use to save game
func overwriteSaveFile(saveData: Dictionary):
	gameData.overwrite(saveData)

#use to save game
func clearSaveFile():
	gameData.clear()
	GameStateHolder.initGameState()

func restoreDefaultSettings():
	settingsData.clear()
