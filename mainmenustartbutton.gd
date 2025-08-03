extends Button

@export_file("*.tscn") var level_select_scene: String

func _on_pressed() -> void:
	get_tree().change_scene_to_file(level_select_scene)
