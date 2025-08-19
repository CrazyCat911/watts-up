extends Control

@onready var next = Loading.next

func _ready() -> void:
	ResourceLoader.load_threaded_request(next)

func _process(delta: float) -> void:
	var progress := []
	ResourceLoader.load_threaded_get_status(next, progress)
	
	$ProgressBar.value = progress[0] * 100
	
	if progress[0] == 1:
		var packed_scene = ResourceLoader.load_threaded_get(next)
		get_tree().change_scene_to_packed(packed_scene)
