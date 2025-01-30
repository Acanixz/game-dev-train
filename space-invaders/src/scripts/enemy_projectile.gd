class_name EnemyProjectile
extends Projectile

func _enter_tree():
	# Enemy projectiles are either lightning or rocket
	const POSSIBLE_TYPES: Array[ProjectileType] = [ProjectileType.ROCKET, ProjectileType.LIGHTNING]
	projectile_type = POSSIBLE_TYPES[randi() % 2]

func _on_body_entered(body:Node2D) -> void:
	if body is Player:
		queue_free()
		body.died.emit()
