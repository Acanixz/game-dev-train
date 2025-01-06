extends TileMapLayer

const POWERUP_SCENE = preload("res://scenes/powerup/powerup.tscn")
const BRICK_PARTICLE = preload("res://resources/brick_particle.tscn")
const BRICK_SOUND = preload("res://resources/brick_break.tscn")

@export var level_id = 0

signal tile_hit(coords: Vector2i)

# Function to check if the level is clear
func _is_level_clear() -> bool:
	var used_cells = get_used_cells()
	for cell in used_cells:
		var alternative_tile_id = get_cell_alternative_tile(cell)
		if alternative_tile_id != 0:  # Assuming ID 0 is the unbreakable brick
			return false
	return true

func _on_tile_hit(tile_coords: Vector2i) -> void:
	var world_coords = map_to_local(tile_coords)
	var tile_alt = get_cell_alternative_tile(tile_coords)
	var tile_atlas_coords = get_cell_atlas_coords(tile_coords)
	var tile_data = get_cell_tile_data(tile_coords)
	
	if tile_data == null: return
	
	if tile_alt != 0:
		var brick_particle: CPUParticles2D = BRICK_PARTICLE.instantiate()
		brick_particle.color = tile_data.modulate
		brick_particle.emitting = true
		brick_particle.position = world_coords
		
		call_deferred("add_child", brick_particle)
		call_deferred("add_child", BRICK_SOUND.instantiate())
	
	match tile_alt:
		# Unbreakable
		0: pass
		
		# Destroy
		1, 2:
			if tile_alt == 1:
				var powerup = POWERUP_SCENE.instantiate()
				if randi() % 4 == 3:
					powerup.powerup_id = -1
				else:
					powerup.powerup_id = randi() % 2 + 1
				
				powerup.position = world_coords
				get_parent().call_deferred("add_child", powerup)
				get_node("../%ScoreLabel").add_score.emit(40)
			
			set_cell(tile_coords, 0, Vector2i(-1, -1))
		# -1 HP
		_: 
			set_cell(tile_coords, 0, tile_atlas_coords, tile_alt - 1)
		
	get_node("../%ScoreLabel").add_score.emit(10)
	
	# Level Clear
	if _is_level_clear():
		get_node("../Ball").queue_free()
		if G.levels.size() >= level_id+1:
			var level_completed_ui = get_node("../%LevelCompleted")
			
			level_completed_ui.get_node("Score").text = "Score: " + str(get_node("../%ScoreLabel").score)
			level_completed_ui.visible = true
		else:
			%GameOver.get_node("Score").text = "Final Score: %s" % str(get_node("../%ScoreLabel").score)
			%GameOver.visible = true
