class_name Level
extends TileMapLayer

## Returns map completion rate as a float [0, 1]
func get_completion_rate() -> float:
	return $Player.size * 1.0 / get_used_cells().size()
	
## Returns all available positions in the grid for a new item
func get_available_cells() -> Array[Vector2i]:
	var available_cells: Array[Vector2i] = get_used_cells()
	var snake_cells: Array[Vector2i] = $Player.get_used_cells()
	var item_cells: Array[Vector2i] = $Items.get_used_cells()
	
	return available_cells.filter(func(element):
		# Snake must not be in the tile, neither an existing item
		return not snake_cells.has(element) and not item_cells.has(element)
	)
