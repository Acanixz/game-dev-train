extends RigidBody2D

@export var speed = 350
@export var initial_velocity = Vector2(0, speed)
var tile_position = Vector2.ZERO

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	linear_velocity = initial_velocity
	freeze = false

func _physics_process(delta: float) -> void:
	var collision_data = move_and_collide(linear_velocity * delta, true)
	if not collision_data: return
	
	var collider = collision_data.get_collider()
	if collider is TileMapLayer:
		tile_position = collider.local_to_map(collision_data.get_position() + (collision_data.get_travel() * -2))

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var velocity = state.linear_velocity.normalized() * speed
	state.linear_velocity = velocity

func _on_body_entered(body: Node) -> void:
	if body is Player:
		linear_velocity = linear_velocity + (body.position.direction_to(position) * 255)
	
	if body is TileMapLayer:
		var tile_data = body.get_cell_tile_data(tile_position)
		var tile_alt = body.get_cell_alternative_tile(tile_position)
		var tile_atlas_coords = body.get_cell_atlas_coords(tile_position)
		match tile_alt:
			# Unbreakable
			0: pass
			
			# Destroy
			1, 2:
				if tile_alt == 1:
					# TODO: Add powerups
					pass
				body.set_cell(tile_position, 0, Vector2i(-1, -1))
			
			# -1 HP
			_: body.set_cell(tile_position, 0, tile_atlas_coords, tile_alt - 1)
		
		
