extends Node2D

@export var item_type: String
@export var poly: PackedVector2Array

signal placed() ## Signals when the panel is placed
signal deselected() ## Signals when the panel is deselected

func _ready() -> void:
	poly = PolygonUtils.shape_to_polygon($Area2D/CollisionPolygon2D)
	
	print("Adding %s" % poly)

func _process(_delta: float) -> void:
	global_position = get_global_mouse_position()
	
	if Input.is_action_just_pressed("click"):
		placed.emit()
	if Input.is_action_just_pressed("deselect"):
		deselected.emit()
