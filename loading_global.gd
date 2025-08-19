extends Node

var screen: PackedScene = preload("uid://befb7n6o54ddo") ## Loading screen scene
var next: String = "" ## Scene to load to

func load_with_screen(to: String):
	next = to
	get_tree().change_scene_to_packed(screen)
