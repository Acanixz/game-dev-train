class_name Troop
extends Node2D

const SMALL_INVADER: PackedScene = preload("res://scenes/invader/small_invader.tscn")
const MEDIUM_INVADER: PackedScene = preload("res://scenes/invader/medium_invader.tscn")
const LARGE_INVADER: PackedScene = preload("res://scenes/invader/large_invader.tscn")

signal moved_down
signal invader_died

@export_category("Troop Properties")
@export var troop_size: Vector2i = Vector2i(11, 5)
@export var spacing: Vector2 = Vector2(20, 32)

var invaders: Array[Variant] = []
var move_direction: Vector2 = Vector2(8,0):
	set(value):
		previous_move_direction = move_direction
		move_direction = value
var previous_move_direction: Vector2 = move_direction
var bounds: Array[float] = []

func _ready() -> void:
	# Set boundaries
	var bound_pos: float = troop_size.x * spacing.x + 32
	bounds.append(-bound_pos)
	bounds.append(bound_pos)
	
	# Spawn enemies
	for column in range(troop_size.x):
		invaders.append([])
		for row in range(troop_size.y):
			var selected_alien: PackedScene
			if row < 2:
				selected_alien = LARGE_INVADER
			elif row < 4:
				selected_alien = MEDIUM_INVADER
			else:
				selected_alien = SMALL_INVADER
		
			var invader: Invader = selected_alien.instantiate()
			invader.position = Vector2(spacing.x * column - (spacing.x * troop_size.x/2), spacing.y * -row)
			call_deferred("add_child", invader)
			invaders[column].append(invader)
	
## Returns all columns that have at least one alien alive
func get_alive_columns() -> Array[int]:
	var result: Array[int] = []
	for column in range(troop_size.x):
		for row in range(troop_size.y):
			if is_instance_valid(invaders[column][row]):
				result.append(column)
				break
	return result
	
## Difficulty scaling
func _on_invader_died() -> void:
	$Tick.wait_time = 1 - (.95 * get_completion_rate())
	
## Returns the X position of the selected corner
func get_corner_position(direction: bool):
	var alive_columns: Array[int] = get_alive_columns()
	
	# false = Left | true = Right
	var target_index: int = alive_columns[-1] if direction else alive_columns[0]

	# Return X coord of the first alien found
	for row in range(troop_size.y):
		if is_instance_valid(invaders[target_index][row]):
			return invaders[target_index][row].position.x
	return 0
	
## Returns the Y pos of the bottommost alien
func get_bottom_position() -> float:
	var result: float = -1000
	var alive_columns: Array[int] = get_alive_columns()
	
	# Check only alive columns
	for column in alive_columns:
		for row in range(troop_size.y):
			if is_instance_valid(invaders[column][row]):
				# Get the alien position closest to 0 (considering troop is at negative Y and going up)
				var invader: Invader = invaders[column][row]
				result = invader.global_position.y if invader.global_position.y > result else result
	return result
				
## Returns the instance of the bottommost alien
func get_last_alien(column: int) -> Invader:
	for row in range(troop_size.y):
		if is_instance_valid(invaders[column][row]):
			return invaders[column][row]
	return null
	
## Returns the completion rate as a float
func get_completion_rate() -> float:
	var alive_aliens: int = 0
	var total_aliens: int = troop_size.x * troop_size.y
	for column in range(troop_size.x):
		for row in range(troop_size.y):
			if is_instance_valid(invaders[column][row]):
				alive_aliens += 1
	
	return 1.0 * (total_aliens - alive_aliens)/total_aliens if alive_aliens > 0 else 1.0
	
## Chooses one of the alive columns and then requests to shoot
func choose_and_shoot() -> void:
	var alive_columns: Array[int] = get_alive_columns()
	if alive_columns.size() == 0: return
	
	var selected_index: int = randi() % alive_columns.size()
	var bottom_alien: Invader = get_last_alien(alive_columns[selected_index])
	
	if not is_instance_valid(bottom_alien): return
	bottom_alien.shoot()

## Move tick
func _on_tick_timeout() -> void:
	# Stop all timers if troop is dead
	if get_completion_rate() == 1:
		$Tick.stop()
		$ShootTimer.stop()
		return

	# Play random tick sound
	var tick_sounds: Array[AudioStreamPlayer] = [$Tick1, $Tick2]
	G.random_pitch_and_play(tick_sounds[randi() % 2])

	# Move all troops individually and animate them
	for column in range(troop_size.x):
		for row in range(troop_size.y):
			if is_instance_valid(invaders[column][row]):
				var invader: Invader = invaders[column][row]
				var sprite: AnimatedSprite2D = invader.get_node("Sprite")
				sprite.frame = 1 if sprite.frame == 0 else 0
				invader.global_translate(move_direction)

	# Move down if reached horizontal boundaries
	if (move_direction.x > 0 and get_corner_position(true) >= bounds[1]) or (move_direction.x < 0 and get_corner_position(false) <= bounds[0]):
		move_direction = Vector2(0, spacing.y)
		return

	# Move in opposite horizontal direction if moving down
	if (move_direction.y > 0):
		moved_down.emit()
		move_direction = previous_move_direction * -1
		return

## Shoot tick
func _on_shoot_timer_timeout() -> void:
	if get_completion_rate() == 1: return
	choose_and_shoot()