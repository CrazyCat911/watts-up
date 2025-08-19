extends Button

func _ready() -> void:
	self.pressed.connect(_on_press)

func _on_press():
	Loading.load_with_screen(get_meta("scene"))
