class_name Player
extends StaticBody2D

@export var move_speed = 255
@export var player_id = 0
var initial_position

func _ready() -> void:
	initial_position = global_position

func _process(delta: float) -> void:
	global_position.x = initial_position.x

func _physics_process(delta: float) -> void:
	if player_id == 0: return
	
	var move_vector = Vector2(0,0)
	if Input.is_action_pressed("P%s_UP" % player_id):
		move_vector = Vector2(0, -move_speed * delta)
	if Input.is_action_pressed("P%s_DOWN" % player_id):
		move_vector = Vector2(0, move_speed * delta)
	
	if move_vector != Vector2.ZERO: move_and_collide(move_vector)
