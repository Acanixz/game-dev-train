extends Node

const SCENES: Array[String] = [
	"res://scenes/main/main.tscn",
	"res://scenes/level/level.tscn",
]

func get_level() -> Node:
	return get_tree().root.get_node("Level")
	
func load_scene(id: int = 0):
	var target_scene: int = id if id > 0 and id < SCENES.size() else 0
	get_tree().change_scene_to_file(SCENES[target_scene])

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("fullscreen_toggle"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN else DisplayServer.WINDOW_MODE_MAXIMIZED)