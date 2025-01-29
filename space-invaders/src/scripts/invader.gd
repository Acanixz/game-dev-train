class_name Invader
extends AnimatableBody2D

signal died

const ENEMY_PROJECTILE: PackedScene = preload("res://scenes/projectile/final/enemy_projectile.tscn")
const POP_EFFECT: PackedScene = preload("res://scenes/effects/pop_effect.tscn")

func shoot():
	var projectile: EnemyProjectile = ENEMY_PROJECTILE.instantiate()
	projectile.position = Vector2(position.x, position.y + 10)
	get_node("/root/Level/Projectiles").call_deferred("add_child", projectile)
	
func _on_died():
	var effect: Node = POP_EFFECT.instantiate()
	effect.position = position
	get_parent().call_deferred("add_child", effect)
	queue_free()