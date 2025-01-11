class_name Player
extends TileMapLayer

## The player is a tilemap responsible for controlling the snake's movement
## and functionality

@export_category("Snake Properties")
## Size of the snake
@export var size = 3:
	set(value):
		# Snake must always have a head, body and tail
		if size < 3: return
		
		size = value
		tick_speed = 1 - clamp(size * 0.15, .1, .75)

## Interval in seconds in which the snake moves
var tick_speed: float = .25:
	set(value):
		tick_speed = value
		$Tick.start(value)

## Tiles occupied by the snake, first index is tail, last one is head
#var snake_tiles = [
	#Vector2i(-2,0),
	#Vector2i(-1,0),
	#Vector2i(0,0),
#]

var snake_tiles = [
	{'pos': Vector2i(-2,0), 'rot': Vector2i(0,0)},
	{'pos': Vector2i(-1,0), 'rot': Vector2i(0,0)},
	{'pos': Vector2i(0,0), 'rot': Vector2i(0,0)},
]
## Snake's head direction, defines where
## it will go in the next tick
var snake_direction: Vector2i = Vector2i(1,0):
	set(value):
		# Snake can't turn 180 degrees
		if snake_tiles[snake_tiles.size() - 1].pos + value == snake_tiles[snake_tiles.size() - 2].pos:
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
	# TODO: Implement snake sprite update
	
	snake_tiles.append({
		'pos': snake_tiles[snake_tiles.size() - 1].pos + snake_direction,
		'rot': snake_direction
	})
	
	set_cell(snake_tiles.pop_front().pos)
	
	for i in range(snake_tiles.size()):
		var atlas_coords = Vector2i(0,0)
		if i == 0:
			atlas_coords.y = 1
		else:
			if i < snake_tiles.size()-1:
				if snake_tiles[i].rot != snake_tiles[i+1].rot:
					atlas_coords.y = 0
				else:
					atlas_coords.y = 2
			
		if i == snake_tiles.size() - 1:
			atlas_coords.y = 3
		
		atlas_coords.x = abs(
			(snake_tiles[i].rot.x + snake_tiles[i].rot.y * 2 + 1)
			 % 4
			)
		set_cell(snake_tiles[i].pos, 0, atlas_coords)
	
