extends CharacterBody2D

@export var move_speed = 5

func _physics_process(delta: float) -> void:
	var move = Input.get_vector("p1_left","p1_right","EMPTY","EMPTY") * move_speed
	
	move_and_collide(move)
	global_position.y = 0
