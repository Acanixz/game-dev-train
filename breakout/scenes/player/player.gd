class_name Player
extends CharacterBody2D

@export var base_move_speed = 5
var move_speed = 5

func _physics_process(delta: float) -> void:
	var move = (
			Input.get_vector("p1_left","p1_right","EMPTY","EMPTY") * 
			move_speed * 
			(.5 if int(Input.is_action_pressed("p1_slow")) else 1 )
		)
	
	move_and_collide(move)
	global_position.y = 0
