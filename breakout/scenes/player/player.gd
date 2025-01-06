class_name Player
extends CharacterBody2D

@export var base_move_speed = 5
var move_speed = 5:
	set(value):
		move_speed = value
		$SpeedupParticle.emitting = move_speed > base_move_speed

func _physics_process(_delta: float) -> void:
	var move = (
			Input.get_vector("p1_left","p1_right","EMPTY","EMPTY") * 
			move_speed * 
			(.5 if Input.is_action_pressed("p1_slow") else 1.0 )
		)
	
	move_and_collide(move)
	global_position.y = 0
