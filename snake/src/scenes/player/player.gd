class_name Player
extends TileMapLayer

## The player is a tilemap responsible for controlling the snake's movement
## and functionality

## Size of the snake
@export var size = 3:
	set(value):
		# Snake must always have a head, body and tail
		if size < 3: return
		
		size = value
		tick_speed = 1 - clamp(size * 0.15, .1, .75)

## Interval in seconds in which the snake moves
@export var tick_speed: float = 1:
	set(value):
		tick_speed = value
		$Tick.start(value)

## Tiles occupied by the snake, first index is tail, last one is head
var snake_tiles = [
	Vector2i(-2,0),
	Vector2i(-1,0),
	Vector2i(0,0),
]

## Snake's head direction, defines where
## it will go in the next tick
var snake_direction: Vector2i = Vector2i(1,0):
	set(value):
		# Snake can't turn 180 degrees
		if snake_tiles[snake_tiles.size() - 1] + value == snake_tiles[snake_tiles.size() - 2]:
			return
		
		# Snake can't move diagonally, nor can it stop
		if value.x == value.y:
			return
		
		snake_direction = value

func _process(delta: float) -> void:
	snake_direction = Input.get_vector("left", "right", "up", "down")

func _ready() -> void:
	$Tick.start(tick_speed)

func _on_tick_timeout() -> void:
	pass
	# TODO: Implement snake_tiles movement logic
	# TODO: Implement snake sprite update
