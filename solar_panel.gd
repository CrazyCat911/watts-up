extends Node2D

@export var item_type: String

signal placed() ## Signals when the panel is placed
signal deselected() ## Signals when the panel is deselected


func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
	
	if Input.is_action_just_pressed("click"):
		placed.emit()
	if Input.is_action_just_pressed("deselect"):
		deselected.emit()
