class_name Troop
extends Node2D

const SMALL_INVADER: PackedScene = preload("res://scenes/invader/small_invader.tscn")
const MEDIUM_INVADER: PackedScene = preload("res://scenes/invader/medium_invader.tscn")
const LARGE_INVADER: PackedScene = preload("res://scenes/invader/large_invader.tscn")
const UFO: PackedScene = preload("res://scenes/invader/ufo.tscn")

@export_category("Troop Properties")
@export var troop_size: Vector2i = Vector2i(11, 5)
@export var spacing: Vector2 = Vector2(20, 32)

var invaders: Array[Variant] = []
var move_direction: Vector2 = Vector2(8,0)
var bounds = []

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
			
func _on_tick_timeout():
	var tick_sounds: Array[AudioStreamPlayer] = [$Tick1, $Tick2]
	G.random_pitch_and_play(tick_sounds[randi() % 2])
	
	# TODO: Implement troop movement
	# position += move_direction
	# if move_direction.x 
	
## Returns all columns that have at least one alien alive
func get_alive_columns() -> Array[int]:
	var result: Array[int] = []
	for column in range(troop_size.x):
		for row in range(troop_size.y):
			if is_instance_valid(invaders[column][row]):
				result.append(column)
				break
	return result
	
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
	
	return 1.0 * (total_aliens - alive_aliens)/total_aliens if alive_aliens > 0 else 1