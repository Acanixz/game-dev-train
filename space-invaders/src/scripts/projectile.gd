class_name Projectile
extends Area2D

const POP_EFFECT: PackedScene = preload("res://scenes/effects/pop_effect.tscn")

const HITSCANS: Array[PackedScene] = [
	preload("res://scenes/barricade_hitscan/variants/laser_explosion.tscn"),
	preload("res://scenes/barricade_hitscan/variants/rocket_explosion.tscn"),
	preload("res://scenes/barricade_hitscan/variants/lightning_explosion.tscn")
]

## Type of projectile, each one has a different explosion when hitting a barricade
enum ProjectileType {
	LASER,
	ROCKET,
	LIGHTNING,
}

@export_category("Projectile Properties")
@export var projectile_type: ProjectileType
@export var velocity: float = 100

## Prevents visibility despawn from deleting before effect is completed
var effect_in_progress: bool = false

func _ready() -> void:
	# Load animations for the expected type
	const ANIMATIONS: Array[String] = ["laser", "rocket", "lightning"]
	$Sprite.play(ANIMATIONS[projectile_type])
	
## Projectile constantly moves vertically, relative to its rotation
func _physics_process(delta: float) -> void:
	var up_direction: Vector2 = Vector2(0, -1).rotated(rotation)
	position = position + (Vector2(0, velocity) * delta * up_direction)

func delete_projectile(pop: bool):
	effect_in_progress = pop
	# Hide projectile
	visible = false
	$Collision.set_deferred("disabled", true)
	
	if pop:
		# Show pop effect
		var effect: Node = POP_EFFECT.instantiate()
		effect.position = position
		get_parent().call_deferred("add_child", effect)

		# Play sound
		G.random_pitch_and_play($ShotCollide)
		await $ShotCollide.finished
		
	# Self-delete
	queue_free()

func _on_area_entered(area:Area2D) -> void:
	# Projectiles can cancel each other
	if area is Projectile:
		delete_projectile(true)
		return
	
func _on_body_entered(body: Node2D) -> void:
	if is_queued_for_deletion(): return
	
	if body.name == "Barricade":
		var hitscan: Node = HITSCANS[projectile_type].instantiate()
		hitscan.position = position
		get_parent().call_deferred("add_child", hitscan)
		delete_projectile(false)

func _on_visibility_screen_exited() -> void:
	if effect_in_progress: return
	queue_free()
	