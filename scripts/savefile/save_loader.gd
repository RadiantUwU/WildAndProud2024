extends Node

class_name SaveLoader

static var gameData: GameData
static var settingsData = SettingsData.new()
static var currentGameSlot: int = -1

func _ready():
	settingsData.loadFile()

#use to load saveFile
func loadSaveFile(slot: int):
	currentGameSlot = slot
	gameData = GameData.new("savefile_"+str(currentGameSlot))
	gameData.loadFile()
	GameStateHolder.initGameState(gameData)

#use to save game
func overwriteSaveFile(saveData: Dictionary):
	gameData.overwrite(saveData)

#use to clear game save
func clearSaveFile(slot: int):
	gameData.clear()
	GameStateHolder.initGameState(gameData)

func restoreDefaultSettings():
	settingsData.clear()
