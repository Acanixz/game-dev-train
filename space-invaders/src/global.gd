extends Node

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen_toggle"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN else DisplayServer.WINDOW_MODE_MAXIMIZED)
		get_viewport().set_input_as_handled()
	
## Sums a random pitch between -0.05 and +0.05, then plays the sound
## Prevents audio fatigue
func random_pitch_and_play(sound: AudioStreamPlayer, base_pitch: float = 1):
	sound.pitch_scale = base_pitch + (randf_range(-0.05, 0.05))
	sound.play()
	