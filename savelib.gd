extends Node

var savegame_path = "user://savegame.save"

func save(data) -> void: ## Saves [param data]. To load, use [method SaveLib.load]
	var file = FileAccess.open(savegame_path, FileAccess.WRITE)
	file.store_var(data, true)

func load() -> Variant: ## Loads data from the location made by [method SaveLib.save]
	if FileAccess.file_exists(savegame_path):
		var file = FileAccess.open(savegame_path, FileAccess.READ)
		
		var data = file.get_var(true)
		return data
	
	return
