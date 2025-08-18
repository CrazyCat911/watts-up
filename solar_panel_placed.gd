extends Node2D

@export var item_type: String
@export var poly: PackedVector2Array

signal delete(node: Node2D)

func _init() -> void:
	var area_node: Area2D = $Area2D
	area_node.input_pickable = true

	poly = PolygonUtils.shape_to_polygon($Area2D/CollisionPolygon2D)
	
	print("Placed %s" % poly)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		if Geometry2D.is_point_in_polygon(get_global_mouse_position(), poly):
			delete.emit(self)
