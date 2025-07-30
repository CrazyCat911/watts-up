extends Node2D

signal placed() ## Signals when the panel is placed

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
	
	if Input.is_action_just_pressed("click"):
		placed.emit()
