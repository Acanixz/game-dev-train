class_name Player
extends Node2D

@onready var paddle = $Paddle
@onready var score_display = $ScoreDisplay
var ball_scene = preload("res://scenes/ball/ball.tscn")

@export var player_id = 0
@export var move_speed = 255
@export var score = 0:
	set(value):
		score = value
		score_display.text = str(value)
		
		if value < 3:
			var new_ball = ball_scene.instantiate()
			new_ball.initial_velocity = new_ball.initial_velocity * position.normalized() * -1
			get_parent().call_deferred("add_child", new_ball)
		else:
			get_parent().game_over.emit(self)

var initial_position

func _ready() -> void:
	initial_position = global_position

func _process(_delta: float) -> void:
	paddle.global_position.x = initial_position.x

func _physics_process(delta: float) -> void:
	if player_id == 0: return
	
	var move_vector = Vector2(0,0)
	if Input.is_action_pressed("P%s_UP" % player_id):
		move_vector = Vector2(0, -move_speed * delta)
	if Input.is_action_pressed("P%s_DOWN" % player_id):
		move_vector = Vector2(0, move_speed * delta)
	
	if move_vector != Vector2.ZERO: paddle.move_and_collide(move_vector)
