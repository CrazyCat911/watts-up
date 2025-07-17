extends Node

var savegame_path = "user://savegame.save"

func save(data) -> void:
	var file = FileAccess.open(savegame_path, FileAccess.WRITE)
	file.store_var(data, true)

func load() -> Variant:
	if FileAccess.file_exists(savegame_path):
		var file = FileAccess.open(savegame_path, FileAccess.READ)
		
		var data = file.get_var(true)
		return data
	
	return
