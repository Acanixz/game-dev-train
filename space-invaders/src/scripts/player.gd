class_name Player
extends AnimatableBody2D

signal died

@export_category("Tank Properties")
@export var base_move_speed: float = 2.5
@export var weapon_cooldown: float = 1.5
@export var lives: int = 3

var move_speed: float = base_move_speed

func _physics_process(_delta: float) -> void:
	var move: Vector2 = (
			   Input.get_vector("move_left","move_right","EMPTY","EMPTY") *
			   move_speed *
			   (.5 if Input.is_action_pressed("slow") else 1.0 )
			   )

	move_and_collide(move)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		print("pew")
		# TODO: Implement shooting mechanic for player
		get_viewport().set_input_as_handled()

## Death behavior
func _on_died() -> void:
	lives -= 1
	
	# Pause scene and change to dead sprite
	$Sprite.animation = 'dead'
	$DeathSound.play()
	get_tree().paused = true
	
	if lives > 0:
		# Stay dead for a while, then resume game
		# TODO: Clear projectiles and UFO
		await get_tree().create_timer(3).timeout
		
		$Fire.restart()
		$Smoke.restart()
		$Sprite.animation = 'alive'
		
		get_tree().paused = false
	else:
		pass # TODO: Implement game over behavior