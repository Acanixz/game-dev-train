extends Area2D

@export var destroy_chance: int = 30

func _ready():
	body_entered.connect(_on_body_entered)

func _destroy_tiles_hit(tilemap: TileMapLayer) -> void:
	var extents: Array[Variant] = [
		global_position.x - $CollisionShape2D.shape.size.x/2,
		global_position.x + $CollisionShape2D.shape.size.x/2,
		global_position.y - $CollisionShape2D.shape.size.y/2,
		global_position.y + $CollisionShape2D.shape.size.y/2,
	]
	
	# For every pixel in the collision box
	for x in range(extents[0], extents[1]):
		for y in range(extents[2], extents[3]):
			# Roll a chance for destruction of the tile
			var destroy_roll: int = randi() % 100
			if destroy_roll < destroy_chance:
				tilemap.set_cell(Vector2(x, y))
	#queue_free()

func _on_body_entered(body) -> void:
	if body is TileMapLayer:
		_destroy_tiles_hit(body)