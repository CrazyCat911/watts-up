extends Node

func is_polygon_node_fully_contained(poly_a_node: Polygon2D, poly_b_node: Polygon2D) -> bool: ## Returns [code]true[/code] if [param poly_a_node] is fully inside [param poly_b_node]
	var poly_a: PackedVector2Array = get_global_polygon(poly_a_node)
	var poly_b: PackedVector2Array = get_global_polygon(poly_b_node)

	# Ensure both polygons are counter-clockwise
	if Geometry2D.is_polygon_clockwise(poly_a):
		poly_a.reverse()

	if Geometry2D.is_polygon_clockwise(poly_b):
		poly_b.reverse()

	# If clipping returns an empty result, poly_b is fully inside poly_a
	var result = Geometry2D.clip_polygons(poly_a, poly_b)
	return result.is_empty()
	
## Returns [code]true[/code] if [param poly_a] is fully inside [param poly_b]
## Please ensure both polygons are in global space
func is_polygon_fully_contained(poly_a: PackedVector2Array, poly_b: PackedVector2Array) -> bool:
	# Ensure both polygons are counter-clockwise
	if Geometry2D.is_polygon_clockwise(poly_a):
		poly_a.reverse()

	if Geometry2D.is_polygon_clockwise(poly_b):
		poly_b.reverse()

	# If clipping returns an empty result, poly_b is fully inside poly_a
	var result = Geometry2D.clip_polygons(poly_a, poly_b)
	return result.is_empty()

func get_global_polygon(polygon_node: Polygon2D) -> PackedVector2Array: ## Converts a Polygon2D node to global space polygon
	var global_polygon = PackedVector2Array()
	var global_xform = polygon_node.get_global_transform()
	for local_point in polygon_node.polygon:
		global_polygon.append(global_xform * local_point)
	return global_polygon

func shape_to_polygon(collision_shape: CollisionShape2D) -> PackedVector2Array:
	var shape = collision_shape.shape
	
	match shape.get_class():
		"RectangleShape2D":
			var extents = shape.extents
			return PackedVector2Array([
				Vector2(-extents.x, -extents.y),
				Vector2(extents.x, -extents.y),
				Vector2(extents.x, extents.y),
				Vector2(-extents.x, extents.y)
			].map(func(p): return collision_shape.global_transform * p))

		"CircleShape2D":
			var radius = shape.radius
			var points = PackedVector2Array()
			var sides = 16
			for i in range(sides):
				var angle = 2.0 * PI * i / sides
				var point = Vector2(cos(angle), sin(angle)) * radius
				points.append(collision_shape.global_transform * point)
			return points

		"CapsuleShape2D":
			var points = PackedVector2Array()
			var radius = shape.radius
			var height = shape.height
			var sides = 8
			for i in range(sides):
				var angle = PI + PI * i / sides
				var point = Vector2(cos(angle), sin(angle)) * radius + Vector2(0, height / 2)
				points.append(collision_shape.global_transform * point)
			for i in range(sides):
				var angle = PI * i / sides
				var point = Vector2(cos(angle), sin(angle)) * radius - Vector2(0, height / 2)
				points.append(collision_shape.global_transform * point)
			return points

		"ConvexPolygonShape2D":
			return PackedVector2Array(shape.points.map(
				func(p): return collision_shape.global_transform * p))

		"ConcavePolygonShape2D":
			push_warning("ConcavePolygonShape2D is segment-based and may not represent a single polygon.")
			var raw_points = shape.segments
			var points = PackedVector2Array()
			for i in range(0, raw_points.size(), 2):
				points.append(collision_shape.global_transform * raw_points[i])
			return points

		_:
			push_error("Unsupported shape type: %s" % shape.get_class())
			return PackedVector2Array()
