extends TileMapLayer

signal tile_hit(coords: Vector2i)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_tile_hit(tile_coords: Vector2i) -> void:
	var tile_alt = get_cell_alternative_tile(tile_coords)
	var tile_atlas_coords = get_cell_atlas_coords(tile_coords)
	match tile_alt:
		# Unbreakable
		0: pass
		
		# Destroy
		1, 2:
			if tile_alt == 1:
				# TODO: Add powerups
				%ScoreLabel.emit_signal("add_score", 40)
				pass
			set_cell(tile_coords, 0, Vector2i(-1, -1))
		
		# -1 HP
		_: 
			set_cell(tile_coords, 0, tile_atlas_coords, tile_alt - 1)
		
	%ScoreLabel.emit_signal("add_score", 10)
