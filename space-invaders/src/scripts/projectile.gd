class_name Projectile
extends Area2D

const POP_EFFECT: PackedScene = preload("res://scenes/effects/pop_effect.tscn")

@export_category("Projectile Properties")
@export var velocity: float = 100

## Projectile constantly moves vertically, relative to its rotation
func _physics_process(delta: float) -> void:
	var up_direction: Vector2 = Vector2(0, -1).rotated(rotation)
	position = position + (Vector2(0, velocity) * delta * up_direction)
	

func _on_area_entered(area:Area2D) -> void:
	# Projectiles can cancel each other
	if area is Projectile:
		# Hide projectile, show "pop" effect
		visible = false
		$Collision.set_deferred("disabled", true)
		var effect: Node = POP_EFFECT.instantiate()
		effect.position = position
		get_parent().call_deferred("add_child", effect)
		
		# Play sound, then self-delete when it's over
		$ShotCollide.play()
		await $ShotCollide.finished
		queue_free()