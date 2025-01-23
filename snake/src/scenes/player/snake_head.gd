extends Area2D

@onready var snake: Player = get_parent()

## Event handler for boundary/item collision,
## for body collision, check player.gd instead
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Boundaries":
		snake.alive = false

	if body.name == "Items":
		var item_pos = body.local_to_map(position)
		var level: Level = G.get_level()
	
		# Increment snake size and delete item
		snake.size += 1
		body.set_cell(item_pos,0)

		# Add a new item and check for win conditon
		level.add_item()
		if level.get_completion_rate() > 1:
			snake.completed_level.emit()
			snake.get_node("Tick").stop()
		