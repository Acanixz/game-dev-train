extends RigidBody2D

@export var initial_velocity = Vector2(-350, 0)
var speed_up_counter = 0

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	linear_velocity = initial_velocity
	freeze = false

func _physics_process(_delta: float) -> void:
	speed_up_counter += 1
	
	if speed_up_counter > 60:
		speed_up_counter = 0
		apply_central_impulse(linear_velocity * 0.1)

func _on_body_entered(body: Node) -> void:
	
	if body.name == "ScoreArea":
		body.get_parent().score += 1
		queue_free()
	
	if body.get_parent() is Player:
		#print(body.position.distance_to(self.position))
		apply_central_impulse(Vector2(0, body.position.direction_to(self.position).y * 400))
	
	if linear_velocity.length() < 232:
		apply_central_impulse(linear_velocity * 10)
	
	if linear_velocity.normalized().y > 0.95:
		apply_central_impulse(Vector2(linear_velocity.x + 50, 0))
	
	if (linear_velocity.length() > 1200):
		linear_velocity *= .75
