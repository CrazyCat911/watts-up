extends Node

func is_polygon_fully_contained(poly_a_node: Polygon2D, poly_b_node: Polygon2D) -> bool: ## Returns [code]true[/code] if [param poly_a_node] is fully inside [param poly_b_node]
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

func get_global_polygon(polygon_node: Polygon2D) -> PackedVector2Array: ## Converts a Polygon2D node to global space polygon
	var global_polygon = PackedVector2Array()
	var global_xform = polygon_node.get_global_transform()
	for local_point in polygon_node.polygon:
		global_polygon.append(global_xform * local_point)
	return global_polygon
