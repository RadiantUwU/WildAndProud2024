extends Node

class_name GameState

# use this class for current playthrough's player data

var savedData: Dictionary

func initGameState(gameData: GameData):
	savedData = gameData.data

func updateSaveFile():
	Save_Loader.overwriteSaveFile(savedData)
