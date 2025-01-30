class_name Projectile
extends Area2D

const POP_EFFECT: PackedScene = preload("res://scenes/effects/pop_effect.tscn")

## Type of projectile, each one has a different explosion when hitting a barricade
enum ProjectileType {
	LASER,
	ROCKET,
	LIGHTNING,
}

@export_category("Projectile Properties")
@export var projectile_type: ProjectileType
@export var velocity: float = 100

## Prevents visibility despawn from deleting before area processing is done
var checking_area: bool = false

func _ready() -> void:
	# Load animations for the expected type
	const ANIMATIONS: Array[String] = ["laser", "rocket", "lightning"]
	$Sprite.play(ANIMATIONS[projectile_type])
	
## Projectile constantly moves vertically, relative to its rotation
func _physics_process(delta: float) -> void:
	var up_direction: Vector2 = Vector2(0, -1).rotated(rotation)
	position = position + (Vector2(0, velocity) * delta * up_direction)
	

func _on_area_entered(area:Area2D) -> void:
	checking_area = true
	# Projectiles can cancel each other
	if area is Projectile:
		# Hide projectile, show "pop" effect
		visible = false
		$Collision.set_deferred("disabled", true)
		var effect: Node = POP_EFFECT.instantiate()
		effect.position = position
		get_parent().call_deferred("add_child", effect)
		
		# Play sound, then self-delete when it's over
		G.random_pitch_and_play($ShotCollide)
		await $ShotCollide.finished
		queue_free()
		checking_area = false
		return
	
	checking_area = false

func _on_visibility_screen_exited() -> void:
	while checking_area:
		await get_tree().create_timer(.5).timeout
	queue_free()
