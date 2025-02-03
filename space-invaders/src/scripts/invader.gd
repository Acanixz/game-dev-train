class_name Invader
extends AnimatableBody2D

const ENEMY_PROJECTILE: PackedScene = preload("res://scenes/projectile/final/enemy_projectile.tscn")
const POP_EFFECT: PackedScene = preload("res://scenes/effects/pop_effect.tscn")

signal died

## Score given when the player destroys the alien
@export var score: int = 0

## TODO: Remove keybinds for this action before release
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DEBUG_BUTTON"):
		died.emit()
		get_viewport().set_input_as_handled()

## Shoots an enemy projectile downwards
func shoot():
	var projectile: EnemyProjectile = ENEMY_PROJECTILE.instantiate()
	projectile.global_position = Vector2(global_position.x, global_position.y + 10)
	get_node("/root/Level/Projectiles").call_deferred("add_child", projectile)

## Triggers during death
func _on_died():
	# Alert troop to death
	var parent: Node = get_parent()
	if parent is Troop:
		parent.invader_died.emit()
		
	# Pop effect
	var effect: Node = POP_EFFECT.instantiate()
	effect.position = position
	get_parent().call_deferred("add_child", effect)
	
	# Award score to player
	G.add_score(score)
	
	# Delete
	queue_free()