extends Control

var button_script: Script = load("uid://d2rkbr7oojmlu") # res://send_to_scene_button.gd

@export_file("*.tscn") var main_menu_scene: String
@onready var grid_container: GridContainer = $GridContainer

func _ready() -> void:
	var level_select_button_theme = Theme.new()
	level_select_button_theme.default_font_size = 100

	var levels = ResourceLoader.load("res://levels.tres").get("data")

	var i := 1

	for level in levels:
		var button = Button.new()
		var icon = ResourceLoader.load(level.get("img"))

		button.set_meta("scene", level.get("scene"))
		button.text = str(i)
		button.theme = level_select_button_theme
		button.icon = icon
		button.set_script(button_script)
		grid_container.add_child(button)
		i += 1
	
	await get_tree().process_frame
	grid_container.position = Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width") / 2 - grid_container.size.x / 2,
		ProjectSettings.get_setting("display/window/size/viewport_height") / 2 - grid_container.size.y / 2
	)
	
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(main_menu_scene)
