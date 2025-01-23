class_name Level
extends TileMapLayer

func _ready() -> void:
	add_item()

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

## Adds an item in an available cell in the grid
func add_item(id: int = 0) -> void:
	var available_cells: Array[Vector2i] = get_available_cells()
	if available_cells.size() == 0: return

	# Choose a random cell and set it to the item parameter
	var selected_cell: Vector2i = available_cells[randi() % available_cells.size()]
	$Items.set_cell(selected_cell, id, Vector2i(0,0))

func _on_item_timer_timeout() -> void:
	var completion_rate: float = get_completion_rate()
	var max_items: float = clamp(completion_rate * 20, 1, 5)
	
	if $Items.get_used_cells().size() < max_items:
		add_item()

func _on_player_died() -> void:
	var game_over = $GameUI/GameOver
	var score = game_over.get_node("FinalSize")

	score.text = "Score: %s" % str($Player.size)
	game_over.visible = true
	
func _on_player_completed_level() -> void:
	var win = $GameUI/Win
	win.visible = true