class_name Player
extends TileMapLayer

## The player is a tilemap responsible for controlling the snake's movement
## and functionality

@export_category("Snake Properties")
## Size of the snake
@export var size: int = 3:
	set(value):
		# Snake must always have a head, body and tail
		if size < 3: return
		
		size = value
		tick_speed = 1 - clamp(size * 0.15, .1, .75)

## Each index of the CURVE_ROTATION_DATA
## represents the curved sprite's indexes, 
## each containing two possible triggers
const CURVE_ROTATION_DATA: Array[Variant] = [
	# Right -> Down or Up -> Left
	[
		[Vector2i(1, 0), Vector2i(0, 1)],
		[Vector2i(0, -1), Vector2i(-1, 0)]
	],
	# Down -> Left or Left -> Up
	[
		[Vector2i(0, 1), Vector2i(-1, 0)],
		[Vector2i(1, 0), Vector2i(0, -1)],
	],
	# Left -> Up or Down -> Right
	[
		[Vector2i(-1, 0), Vector2i(0, -1)],
		[Vector2i(0, 1), Vector2i(1, 0)],
	],
	# Up -> Right or Left -> Down
	[
		[Vector2i(0, -1), Vector2i(1, 0)],
		[Vector2i(-1, 0), Vector2i(0, 1)],
	],
]

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

var snake_tiles: Array[Dictionary] = [
	{'pos': Vector2i(-2,0), 'rot': Vector2i(1,0)},
	{'pos': Vector2i(-1,0), 'rot': Vector2i(1,0)},
	{'pos': Vector2i(0,0), 'rot': Vector2i(1,0)},
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

## Snake only processes a tick while alive
var alive: bool = true

func _process(_delta: float) -> void:
	snake_direction = Input.get_vector("left", "right", "up", "down")

func _ready() -> void:
	$Tick.start(tick_speed)

func _on_tick_timeout() -> void:
	if not alive: return
	
	snake_tiles.append({
		'pos': snake_tiles[snake_tiles.size() - 1].pos + snake_direction,
		'rot': snake_direction
	})
	
	$Head.position = snake_tiles[snake_tiles.size()-1].pos * 16
	
	if snake_tiles.size() > size:
		set_cell(snake_tiles.pop_front().pos)
	
	for i in range(snake_tiles.size()):
		var current_tile: Dictionary = snake_tiles[i]
		var next_tile = snake_tiles[i+1] if i < snake_tiles.size()-1 else null
		var atlas_coords: Vector2i = Vector2i(0,0)
		
		if i == 0:
			atlas_coords.y = 1
		else:
			if i < snake_tiles.size()-1:
				if current_tile.rot != next_tile.rot:
					atlas_coords.y = 0
				else:
					atlas_coords.y = 2
			
		if i == snake_tiles.size() - 1:
			atlas_coords.y = 3
		
		match atlas_coords.y:
			0:
				var index: int = 0
				for target_coord in CURVE_ROTATION_DATA:
					for target_coord_item in target_coord:
						if current_tile.rot == target_coord_item[0] and next_tile.rot == target_coord_item[1]:
							atlas_coords.x = index
					index += 1
			
			1:
				atlas_coords.x = abs(
				(next_tile.rot.x + next_tile.rot.y * 2 + 1)
				 % 4
				)
			
			_:
				atlas_coords.x = abs(
				(current_tile.rot.x + current_tile.rot.y * 2 + 1)
				 % 4
				)
		
		set_cell(current_tile.pos, 0, atlas_coords)
	
