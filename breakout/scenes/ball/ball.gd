extends RigidBody2D

@export var speed = 500
@export var initial_velocity = Vector2(0, speed)

func _ready() -> void:
	await get_tree().create_timer(5).timeout
	linear_velocity = initial_velocity
	freeze = false

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var velocity = state.linear_velocity.normalized() * speed
	state.linear_velocity = velocity
