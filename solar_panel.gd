extends Node2D

signal placed(polygon: PackedVector2Array) ## Signals when the panel is placed [param location] is the panel's polygon

func _process(delta: float) -> void:
	global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)
	
	if Input.is_action_just_pressed("click"):
		placed.emit()
