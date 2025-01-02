extends TileMapLayer

const POWERUP_SCENE = preload("res://scenes/powerup/powerup.tscn")
const BRICK_PARTICLE = preload("res://resources/brick_particle.tscn")
const BRICK_SOUND = preload("res://resources/brick_break.tscn")

signal tile_hit(coords: Vector2i)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
				%ScoreLabel.add_score.emit(40)
			
			set_cell(tile_coords, 0, Vector2i(-1, -1))
			call_deferred("add_child", BRICK_SOUND.instantiate())
		# -1 HP
		_: 
			set_cell(tile_coords, 0, tile_atlas_coords, tile_alt - 1)
		
	%ScoreLabel.add_score.emit(10)
