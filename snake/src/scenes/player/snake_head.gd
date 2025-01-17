extends Area2D

@onready var snake: Player = get_parent()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Boundaries":
		snake.alive = false

	if body.name == "Items":
		var item_pos = body.local_to_map(position)
		snake.size += 1
		body.set_cell(item_pos,0)

		G.get_level().add_item()
