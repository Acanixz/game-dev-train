extends RigidBody2D

@export var speed = 350
@export var initial_velocity = Vector2(0, speed)
var tile_position = Vector2.ZERO
var fireball = false:
	set(value):
		fireball = value
		const BALL_COLOR = [Color.WHITE, Color.RED]
		$FireballParticle.emitting = value
		$Sprite.modulate = BALL_COLOR[int(value)]

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
		if fireball:
			get_node("../%TileMap").emit_signal("tile_hit", tile_position)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var velocity = state.linear_velocity.normalized() * speed
	state.linear_velocity = velocity

func _on_body_entered(body: Node) -> void:
	if body is Player:
		linear_velocity = linear_velocity + (body.position.direction_to(position) * 255)
		$Bonk.play()
	
	if body is TileMapLayer and not fireball:
		get_node("../%TileMap").emit_signal("tile_hit", tile_position)
	
	if body.name == "DeathBounds":
		get_node("../%LivesUI").remove_life.emit()
		queue_free()
	
	if body.name == "Boundaries":
		$HeavyBonk.play()
