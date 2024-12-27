extends RigidBody2D

@export var initialVelocity = Vector2(-350, 0)
var triggered = false:
	set(value):
		if value == true:
			self.linear_velocity = initialVelocity
		triggered = value
var speed_up_counter = 0

func _physics_process(_delta: float) -> void:
	speed_up_counter += 1
	
	if speed_up_counter > 120:
		speed_up_counter = 0
		apply_central_impulse(linear_velocity * 0.1)

func _on_body_entered(body: Node) -> void:
	if body is Player:
		#print(body.position.distance_to(self.position))
		apply_central_impulse(Vector2(0, body.position.direction_to(self.position).y * 100))
	
	if linear_velocity.length() < 232:
		apply_central_impulse(linear_velocity * 10)
	
	if linear_velocity.normalized().y > 0.95:
		apply_central_impulse(Vector2(linear_velocity.x + 20, 0))
	
	if (linear_velocity.length() > 1200):
		linear_velocity *= .75
