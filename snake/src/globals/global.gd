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