extends Button

@export_file("*.tscn") var main_menu_scene: String


func _on_pressed() -> void:
	get_tree().change_scene_to_file(main_menu_scene)
