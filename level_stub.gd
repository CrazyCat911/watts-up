extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Shop.init_shop({"solar_panel": 1, "mice": 42}, {})

func _on_shop_shop_ready() -> void:
	print("Shop is ready!")

func _on_shop_item_selected(item_name: Variant) -> void:
	print("Item Selected! %s" % item_name)
