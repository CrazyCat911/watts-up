extends Node2D

var selected_item: String
var drag_and_drop_script = load("res://drag_and_drop.gd")

var config: Dictionary = {
	"solar_panel": {
		"texture": load("res://assets/solar_panel.png"),
		"size": 100,
	},
}

func _ready() -> void:
	$Shop.init_shop({"solar_panel": 1, "mice": 42}, {})

func _on_shop_shop_ready() -> void:
	print("Shop is ready!")

func _on_shop_item_selected(item_name: String) -> void:
	print("Item Selected! %s" % item_name)
	selected_item = item_name
	
	var item_sprite := Sprite2D.new()
	var item_collision := Area2D.new()
	var item_collision_shape := CollisionShape2D.new()
	var item_shape := RectangleShape2D.new()
	var item_size: int = config.get(item_name, {}).get("size", 0)
	item_shape.size = Vector2(item_size, item_size)
	item_collision_shape.shape = item_shape
	item_collision.add_child(item_collision_shape)
	item_sprite.add_child(item_collision)
	
	item_sprite.texture = config.get(item_name, {}).get("texture", load("res://assets/solar_panel.png"))
	
	item_sprite.set_script(drag_and_drop_script)
	
	self.add_child(item_sprite)
