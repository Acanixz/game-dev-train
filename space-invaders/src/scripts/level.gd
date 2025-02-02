class_name Level
extends Node2D

const TROOP: PackedScene = preload("res://scenes/invader/troop/troop.tscn")

## Level difficulty, cannot go lower than 1
@export var difficulty: int = 1:
	set(value):
		if value < 1: return
		difficulty = value

var ufo_resource: PackedScene = load("res://scenes/invader/ufo.tscn")
var ufo_direction: int = 1

## Triggered by global.gd when Level can start using difficulty scaling to 
## finish loading the assets
func level_ready():
	var troop: Troop = TROOP.instantiate()
	troop.position = Vector2(0, -128 + clamp(16 * (difficulty-1), 0, 32))
	troop.troop_size = Vector2(8 + clamp(difficulty / 2.0, 0, 5), 5 + clamp(difficulty / 5.0, 0, 2))
	troop.moved_down.connect(_on_troop_moved_down)
	add_child(troop)
	
	print("Level loaded | Difficulty: %s" % difficulty)

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
	ufo.global_position = Vector2(-get_viewport_rect().size.x/2 * ufo_direction, (-get_viewport_rect().size.y * .95) + 60)
	
	ufo.velocity = ufo.BASE_VELOCITY + clamp(10 * difficulty, 10, 50)
	ufo.direction = ufo_direction
	
	# Add UFO to level and invert direction for the next one
	call_deferred("add_child", ufo)
	ufo_direction *= -1

## Clears all projectiles and special aliens during death
func _on_player_died() -> void:
	clear_projectiles()
	clear_special_aliens()
