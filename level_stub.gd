extends Node2D

# Constants
const COLOR_PLACEABLE: Color = Color(0, 1, 0, 0.5)
const COLOR_UNPLACEABLE: Color = Color(1, 0, 0, 0.5)

var selected_item: String
var selected_node: Node2D
var selected_item_poly: PackedVector2Array
var solar_panel_script = load("res://solar_panel.gd")
var item_placeable: bool = false

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
	shop.init_shop({"solar_panel": 1}, {})

func _process(_delta: float) -> void:
	if selected_node:
		var selected_node_size: int = config.get(selected_item).get("size")
		selected_item_poly = PolygonUtils.shape_to_polygon(selected_node.get_node('Area2D/CollisionPolygon2D'))
		item_placeable = PolygonUtils.is_polygon_fully_contained(selected_item_poly, PolygonUtils.get_global_polygon(roof))

		place_helper.show()
		place_helper.size = Vector2(selected_node_size, selected_node_size)
		place_helper.position = - place_helper.size / 2
		place_helper.color = COLOR_PLACEABLE if item_placeable else COLOR_UNPLACEABLE

func _on_shop_shop_ready() -> void:
	print("Shop is ready!")

func _on_shop_item_selected(item_name: String) -> void:
	print("Item Selected! %s" % item_name)
	selected_item = item_name
	
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
	
	item_node.connect('placed', _on_solar_panel_place)
	item_node.add_child(place_helper)
	
	self.add_child(item_node)
	selected_node = item_node

	
func _on_solar_panel_place(polygon: PackedVector2Array):
	if PolygonUtils.is_polygon_fully_contained(polygon, PolygonUtils.get_global_polygon(roof)):
		print("yes")
	else:
		print("no")