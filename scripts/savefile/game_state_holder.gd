extends Node

class_name GameState

var completedSections: Array[String] = []

func initGameState(gameData: GameData):	
	var savedData = Save_Loader.gameData
	completedSections = savedData.safeGet("completedSections", [])
	
func saveCompletedSection(completedSection: String):
	completedSections.append(completedSection)	
	Save_Loader.gameData.setOrPut("completedSections", completedSections)
