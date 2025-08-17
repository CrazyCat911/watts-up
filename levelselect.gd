extends Control

var button_script: Script = load("uid://d2rkbr7oojmlu") # res://send_to_scene_button.gd

@export_file("*.tscn") var main_menu_scene: String
@onready var grid_container: GridContainer = $GridContainer

func _ready() -> void:
	var level_select_button_theme = Theme.new()
	level_select_button_theme.default_font_size = 100
	
	var files: Array[String] = []
	const SEND_TO_FOLDER: String = "res://prelevel/"
	var dir := DirAccess.open(SEND_TO_FOLDER)
	
	if dir:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		
		while file_name:
			if not dir.current_is_dir():
				files.append(file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	
	for file in files:
		var button = Button.new()
		button.set_meta("scene", SEND_TO_FOLDER + file)
		button.text = file.get_file().get_basename()
		button.theme = level_select_button_theme
		button.set_script(button_script)
		grid_container.add_child(button)
	
	await get_tree().process_frame
	grid_container.position = Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width") / 2 - grid_container.size.x / 2,
		ProjectSettings.get_setting("display/window/size/viewport_height") / 2 - grid_container.size.y / 2
	)
	
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(main_menu_scene)
