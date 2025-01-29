class_name EnemyProjectile
extends Projectile

func _on_body_entered(body:Node2D) -> void:
	if body is Player:
		queue_free()
		body.died.emit()
