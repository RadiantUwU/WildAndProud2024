extends SaveData

class_name SettingsData

func _init():
	fileName = "settings"
	saveFile = ConfigFile.new()
	
func loadFile():
	super.loadFile()
	setMusicVolume(getMusicVolume())
	setAmbienceVolume(getAmbienceVolume())
	setMasterVolume(getMasterVolume())
	setSFXVolume(getSFXVolume())

# set SFX volume. Permitted values: 0 - 10
func setSFXVolume(value: int):
	setOrPut("Settings.SFXVolume", max(0, min(10, value)))
	setBus("SFX", linear_to_db(float(value)/10.0))
func getSFXVolume() -> int:
	return safeGet("Settings.SFXVolume", 10)

# set music volume. Permitted values: 0 - 10
func setMusicVolume(value: int):
	setOrPut("Settings.MusicVolume", max(0, min(10, value)))
	setBus("Music", linear_to_db(float(value)/10.0))
func getMusicVolume() -> int:
	return safeGet("Settings.MusicVolume", 10)

# set music volume. Permitted values: 0 - 10
func setAmbienceVolume(value: int):
	setOrPut("Settings.AmbienceVolume", max(0, min(10, value)))
	setBus("Ambience", linear_to_db(float(value)/10.0))
func getAmbienceVolume() -> int:
	return safeGet("Settings.AmbienceVolume", 10)

# set master volume. Permitted values: 0 - 10
func setMasterVolume(value: int):
	setOrPut("Settings.MasterVolume", max(0, min(10, value)))
	setBus("Master", linear_to_db(float(value)/10.0))
func getMasterVolume() -> int:
	return safeGet("Settings.MasterVolume", 10)
	
func setBus(busName, volume_db):
	var busIndex = AudioServer.get_bus_index(busName)
	AudioServer.set_bus_volume_db(busIndex, volume_db)
	AudioServer.set_bus_mute(busIndex, false)
	
