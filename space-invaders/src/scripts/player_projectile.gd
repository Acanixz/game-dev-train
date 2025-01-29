class_name PlayerProjectile
extends Projectile

func _on_body_entered(body:Node2D) -> void:
	if body is Invader:
		queue_free()
		body.died.emit()
