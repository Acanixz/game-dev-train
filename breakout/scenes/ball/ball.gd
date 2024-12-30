extends RigidBody2D

@export var speed = 350
@export var initial_velocity = Vector2(0, speed)

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	linear_velocity = initial_velocity
	freeze = false

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var velocity = state.linear_velocity.normalized() * speed
	state.linear_velocity = velocity

func _on_body_entered(body: Node) -> void:
	if body is Player:
		linear_velocity = linear_velocity + (body.position.direction_to(position) * 255)