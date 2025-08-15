extends Button

func _ready() -> void:
	self.pressed.connect(_on_press)

func _on_press():
	get_tree().change_scene_to_file(get_meta("scene"))
