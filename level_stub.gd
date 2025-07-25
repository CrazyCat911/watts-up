extends Node2D

var selected_item: String
var selected_node: Node2D
var drag_and_drop_script = load("res://drag_and_drop.gd")

var config: Dictionary = {
	"solar_panel": {
		"texture": load("res://assets/solar_panel.png"),
		"size": 100,
	},
}

func _ready() -> void:
	$Shop.init_shop({"solar_panel": 1}, {})

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
	
	item_collision.add_child(item_collision_shape)
	item_node.add_child(item_sprite)
	item_node.add_child(item_collision)
	
	item_node.set_script(drag_and_drop_script)
	
	self.add_child(item_node)
	selected_node = item_node
