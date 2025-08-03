extends Node2D

@export var item_type: String
@export var poly: PackedVector2Array

var mouse_inside: bool = false
signal delete(node: Node2D)

func _init() -> void:
	var area_node: Area2D = $Area2D
	area_node.input_pickable = true
	area_node.mouse_entered.connect(func(): mouse_inside = true)
	area_node.mouse_exited.connect(func(): mouse_inside = false)

	poly = PolygonUtils.shape_to_polygon($Area2D/CollisionPolygon2D)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		if mouse_inside:
			delete.emit(self)
