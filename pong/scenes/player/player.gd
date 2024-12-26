extends CharacterBody2D

@export var move_speed = 255
@export var player_id = 0

func _physics_process(delta: float) -> void:
	if player_id == 0: return
	var move = false
	if Input.is_action_pressed("P%s_UP" % player_id):
		# self.position.y -= move_speed * delta
		self.velocity.y = -move_speed
		move = true
	if Input.is_action_pressed("P%s_DOWN" % player_id):
		# self.position.y += move_speed * delta
		self.velocity.y = move_speed
		move = true
	if move: move_and_slide()
