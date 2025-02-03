class_name Player
extends AnimatableBody2D

const PLAYER_PROJECTILE: PackedScene = preload("res://scenes/projectile/final/player_projectile.tscn")

signal died
signal life_changed(value: int)

@export_category("Tank Properties")
@export var base_move_speed: float = 2.5
@export var weapon_cooldown: float = 1
@export var lives: int = 3:
	set(value):
		if value > 5: value = 5
		lives = value
		life_changed.emit(lives)
		print("LIVES: %s" % lives)

var move_speed: float = base_move_speed
var is_weapon_cooldown: bool = false

func _physics_process(_delta: float) -> void:
	var move: Vector2 = (
			   Input.get_vector("move_left","move_right","EMPTY","EMPTY") *
			   move_speed *
			   (.5 if Input.is_action_pressed("slow") else 1.0 )
			   )

	move_and_collide(move)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		get_viewport().set_input_as_handled()
		if is_weapon_cooldown: return
		
		G.random_pitch_and_play($WeaponSound)
		var projectile: PlayerProjectile = PLAYER_PROJECTILE.instantiate()
		projectile.position = Vector2(position.x, position.y - 10)
		get_node("/root/Level/Projectiles").call_deferred("add_child", projectile)
		
		is_weapon_cooldown = true
		await get_tree().create_timer(weapon_cooldown).timeout
		is_weapon_cooldown = false

## Death behavior
func _on_died() -> void:
	lives -= 1
	
	# Pause scene and change to dead sprite
	$Sprite.animation = 'dead'
	G.random_pitch_and_play($DeathSound)
	get_tree().paused = true
	
	if lives > 0:
		# Stay dead for a while, then resume game
		await get_tree().create_timer(3).timeout
		
		$Fire.restart()
		$Smoke.restart()
		$Sprite.animation = 'alive'
		
		get_tree().paused = false
	else:
		pass # TODO: Implement game over behavior
