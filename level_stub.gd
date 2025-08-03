extends Node2D

# Constants
const COLOR_PLACEABLE: Color = Color(0, 1, 0, 0.5)
const COLOR_UNPLACEABLE: Color = Color(1, 0, 0, 0.5)

var selected_item: String
var selected_node: Node2D
var selected_item_poly: PackedVector2Array
var solar_panel_script = load("res://solar_panel.gd")
var placed_solar_panel_script = load("res://solar_panel_placed.gd")
var item_placeable: bool = false
var placed_items: Array[Node2D] = []

var shop_data: Dictionary[String, int] = {
	"solar_panel": 1
}

@onready var roof: Polygon2D = $Roof
@onready var shop = $Shop
@onready var place_helper: ColorRect = $PlaceHelper

var config: Dictionary = {
	"solar_panel": {
		"texture": load("res://assets/solar_panel.png"),
		"size": 100,
	},
}

func _ready() -> void:
	self.remove_child(place_helper)
	shop.init_shop(shop_data, {})
	await shop.ready

func _process(_delta: float) -> void:
	if selected_node:
		var selected_node_size: int = config.get(selected_item).get("size")
		selected_item_poly = PolygonUtils.shape_to_polygon(selected_node.get_node('Area2D/CollisionPolygon2D'))
		
		# Transform roof polygon to global space
		var roof_global_poly := PackedVector2Array()
		var roof_xform := roof.get_global_transform()
		for p in roof.polygon:
			roof_global_poly.append(roof_xform * p)
		
		item_placeable = is_placement_legal(
			selected_item_poly,
			roof_global_poly,
			placed_items.map(func(v): return PolygonUtils.shape_to_polygon(v.get_node("Area2D/CollisionPolygon2D")))
		)

		place_helper.show()
		place_helper.size = Vector2(selected_node_size, selected_node_size)
		place_helper.position = - place_helper.size / 2
		place_helper.color = COLOR_PLACEABLE if item_placeable else COLOR_UNPLACEABLE

func is_placement_legal(panel_polygon: PackedVector2Array, roof_polygon: PackedVector2Array, blockers) -> bool:
	if !PolygonUtils.is_polygon_fully_contained(panel_polygon, roof_polygon):
		return false

	for v in blockers:
		if PolygonUtils.polygons_are_touching(v, panel_polygon):
			return false

	return true

func _on_shop_item_selected(item_name: String) -> void:
	print("Item Selected! %s" % item_name)
	selected_item = item_name

	if shop_data[item_name] == 0:
		return

	shop_data[item_name] -= 1
	shop.init_shop(shop_data, {})
	
	if selected_node:
		selected_node.queue_free()

	var item_config: Dictionary = config.get(item_name, {})
	
	var item_node := Node2D.new()
	var item_collision := Area2D.new()
	var item_collision_shape := CollisionShape2D.new()
	var item_shape := RectangleShape2D.new()
	var item_size: int = item_config.get("size", 0)
	var item_sprite: Sprite2D = Sprite2D.new()
	var item_texture: Texture2D = item_config.get("texture")
	var texture_size: Vector2 = item_texture.get_size()
	item_shape.size = Vector2(item_size, item_size)
	item_collision_shape.shape = item_shape

	item_sprite.texture = item_config.get("texture")

	item_sprite.scale = item_shape.size / texture_size
	
	item_collision_shape.name = "CollisionPolygon2D"
	item_collision.name = "Area2D"
	item_collision.add_child(item_collision_shape)
	item_node.add_child(item_sprite)
	item_node.add_child(item_collision)
	
	item_node.set_script(solar_panel_script)
	
	item_node.item_type = item_name
	item_node.placed.connect(_on_solar_panel_place)
	item_node.deselected.connect(_on_solar_panel_deselect)
	item_node.add_child(place_helper)
	
	self.add_child(item_node)
	selected_node = item_node

	
func _on_solar_panel_place():
	if item_placeable:
		selected_node.remove_child(place_helper)
		selected_node.set_script(placed_solar_panel_script)
		selected_node.item_type = selected_item
		selected_node.delete.connect(_on_solar_panel_delete)
		placed_items.append(selected_node)
		selected_node = null
		selected_item = ""
		selected_item_poly = PackedVector2Array()
	else: # Potentially play error/bong noise?
		shop_data[selected_item] += 1
		shop.init_shop(shop_data, {})
		selected_node.remove_child(place_helper)
		selected_node.queue_free()
		selected_node = null
		selected_item = ""
		selected_item_poly = PackedVector2Array()

func _on_solar_panel_deselect():
	shop_data[selected_item] += 1
	shop.init_shop(shop_data, {})

	selected_node.remove_child(place_helper)
	selected_node.queue_free()
	selected_node = null
	selected_item = ""
	selected_item_poly = PackedVector2Array()

func _on_solar_panel_delete(node) -> void:
	shop_data[node.item_type] += 1
	shop.init_shop(shop_data, {})
	
	placed_items.remove_at(placed_items.bsearch(node))
	node.queue_free()

func _on_calculate_button_pressed() -> void:
	var label: Label = $Label

	label.text = "Your solar panels produced %.1fKw" % calculate_panel_production(placed_items)

func calculate_panel_production(placed_panels: Array[Node2D]) -> float:
	var sum: float = 0.0
	for panel in placed_panels:
		var polygon: PackedVector2Array = panel.poly
		sum += PolygonUtils.get_polygon_area(polygon) * 0.3

	return sum
