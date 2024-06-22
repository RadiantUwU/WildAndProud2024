extends CanvasGroup

class_name WelcomeScreen

var mainMenu: MainMenu

func _on_play_game_pressed():
	mainMenu.switchByName("play")

func _on_settings_pressed():
	mainMenu.switchByName("settings")

func _on_credits_pressed():
	mainMenu.switchByName("credits")

func _on_quit_pressed():
	get_tree().quit()
