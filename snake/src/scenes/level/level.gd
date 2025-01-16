class_name Level
extends TileMapLayer

func get_completion_rate() -> float:
	return $Player.size * 1.0 / get_used_cells().size()

func get_available_cells() -> Array[Vector2i]:
	var available_cells: Array[Vector2i] = get_used_cells()
	var snake_cells: Array[Vector2i] = $Player.get_used_cells()
	var item_cells: Array[Vector2i] = $Items.get_used_cells()
	
	return available_cells.filter(func(element):
		return not snake_cells.has(element) and not item_cells.has(element)
	)
