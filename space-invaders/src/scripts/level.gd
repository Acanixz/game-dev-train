class_name Level
extends Node2D

var ufo_resource: PackedScene = load("res://scenes/invader/ufo.tscn")
var ufo_direction: int = 1

## Clears all projectiles on screen
func clear_projectiles() -> void:
	for projectile in $Projectiles.get_children():
		projectile.call_deferred("queue_free")

## Clears all aliens that aren't part of a troop
func clear_special_aliens() -> void:
	for node in get_children():
		if node is Invader:
			node.call_deferred("queue_free")

## Player instantly game overs if troops get too close
func _on_troop_moved_down() -> void:
	if $Troop.get_bottom_position() >= $Player.global_position.y - $Troop.spacing.y:
		$Player.lives = 1
		$Player.died.emit()

## Spawns a new UFO
func _on_ufo_timer_timeout() -> void:
	var ufo: Invader = ufo_resource.instantiate()
	ufo.global_position = Vector2($PlayerBounds/Left.shape.distance * ufo_direction, $Boundaries/Top.shape.distance + 60)
	
	## TODO: Scale UFO velocity with difficulty
	ufo.velocity = ufo.BASE_VELOCITY + (10 * 0)
	ufo.direction = ufo_direction
	
	# Add UFO to level and invert direction for the next one
	call_deferred("add_child", ufo)
	ufo_direction *= -1

## Clears all projectiles and special aliens during death
func _on_player_died() -> void:
	clear_projectiles()
	clear_special_aliens()
