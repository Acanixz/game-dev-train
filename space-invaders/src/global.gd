extends Node

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen_toggle"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN else DisplayServer.WINDOW_MODE_MAXIMIZED)
		get_viewport().set_input_as_handled()