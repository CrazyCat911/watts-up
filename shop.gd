extends Control

signal shop_ready ## Signals that the shop is ready
signal item_selected(item_name) ## Signals that an item is selected

var shopdata: Dictionary = {} ## Holds item data in the format {item_name: quantity}

## [param data] - item name to quantity [br]
## [param sprites] - item name to image path
func init_shop(data: Dictionary, sprites: Dictionary) -> void:
	var container_node: VBoxContainer = $VBoxContainer
	
	for child in container_node.get_children():
		child.queue_free()
	
	shopdata = data

	for item_name in shopdata.keys():
		var quantity: int = shopdata[item_name]
		var item_texture_path: String = sprites.get(item_name, "")

		# Create a button to represent the item
		var item_button: Button = Button.new()
		item_button.name = item_name
		item_button.text = "%s x%d" % [item_name, quantity]
		item_button.expand_icon = true
		item_button.alignment = HORIZONTAL_ALIGNMENT_FILL

		# Optional: Add an icon (if the path is valid)
		if item_texture_path != "":
			var texture: Texture2D = load(item_texture_path)
			item_button.icon = texture

		# Connect the 'pressed' signal to a callback
		item_button.pressed.connect(_item_selected.bind(item_name))
		
		container_node.add_child(item_button)

	shop_ready.emit()


func _item_selected(item_name) -> void:
	item_selected.emit(item_name)
