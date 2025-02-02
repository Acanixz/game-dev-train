extends Node

var current_score: int = 0
var high_score_structure: Dictionary = {
		"score": 0,
		"name": "???",
	}
var high_scores: Array

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	for i in range(5):
		high_scores.append(high_score_structure.duplicate())
	
	load_game()
	
	# TEMPORARY, REMOVE AFTER "NEW GAME" BUTTON IS READY 
	await get_tree().create_timer(1).timeout
	load_level(1)
	
## Auto-save
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen_toggle"):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN else DisplayServer.WINDOW_MODE_MAXIMIZED)
		get_viewport().set_input_as_handled()
	
## Sums a random pitch between -0.05 and +0.05, then plays the sound
## Prevents audio fatigue
func random_pitch_and_play(sound: AudioStreamPlayer, base_pitch: float = 1):
	sound.pitch_scale = base_pitch + (randf_range(-0.05, 0.05))
	sound.play()
	
## Loads a level at a specific difficulty
func load_level(difficulty: int = 1):
	if difficulty < 1: return
	
	# Load level scene
	var err: int = get_tree().change_scene_to_file("res://scenes/level/level.tscn")
	if not err:
		# Wait for Level node
		await get_tree().create_timer(.5).timeout
		var level: Level = get_node("/root/Level")
		while not is_instance_valid(level):
			level = get_node("/root/Level")
			await get_tree().create_timer(.1).timeout
		
		# Set values and trigger level_ready
		level.difficulty = difficulty
		level.level_ready()
	
## Resets the current score
func reset_score() -> void:
	current_score = 0
	
## Checks for high-score, then stores if it is
func store_score(username: String) -> void:
	# Check for high-score
	var position: int = -1
	for i in range(high_scores.size()):
		var value: Dictionary = high_scores[i]
		if current_score > value.score:
			position = i
			break

	# Is high-score?
	if position != -1:
		# Store data into structure
		var score_data: Dictionary = high_score_structure.duplicate()
		score_data.name = username
		score_data.score = current_score
		
		# Insert data and remove additional scores
		high_scores.insert(position, score_data)
		if high_scores.size() > 5:
			high_scores.pop_back()
		
	reset_score()

## Adds score to the current run
func add_score(increment) -> void:
	current_score += increment

func save_game() -> void:
	print("Saving game..")
	var save_dict: String = JSON.stringify({
		"high_scores": high_scores
	})
	FileAccess.open("user://space-invaders.save", FileAccess.WRITE).store_line(save_dict)
	print("Game saved")
	
func load_game() -> void:
	if not (FileAccess.file_exists("user://space-invaders.save")): return
	var save_data: String = FileAccess.open("user://space-invaders.save", FileAccess.READ).get_line()
	var parsed_saved = JSON.parse_string(save_data)
	
	print("Save found, loading..")
	
	# SAVE DATA
	high_scores = parsed_saved.high_scores
	
	print("Game loaded")