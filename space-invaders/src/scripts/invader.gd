class_name Invader
extends AnimatableBody2D

signal died

const ENEMY_PROJECTILE: PackedScene = preload("res://scenes/projectile/final/enemy_projectile.tscn")
const POP_EFFECT: PackedScene = preload("res://scenes/effects/pop_effect.tscn")

func shoot():
	var projectile: EnemyProjectile = ENEMY_PROJECTILE.instantiate()
	projectile.global_position = Vector2(global_position.x, global_position.y + 10)
	get_node("/root/Level/Projectiles").call_deferred("add_child", projectile)
	
func _on_died():
	var parent: Node = get_parent()
	if parent is Troop:
		parent.invader_died.emit()
	var effect: Node = POP_EFFECT.instantiate()
	effect.position = position
	get_parent().call_deferred("add_child", effect)
	queue_free()