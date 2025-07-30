extends Node2D

signal placed() ## Signals when the panel is placed

func _process(delta: float) -> void:
	global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	
	if Input.is_action_just_pressed("click"):
		placed.emit()
