class_name Player
extends TileMapLayer

## The player is a tilemap responsible for controlling the snake's movement
## and functionality

## Triggered when the snake dies by any means
signal died

## Triggered when the level is cleared
signal completed_level

@export_category("Snake Properties")
## Size of the snake
@export var size: int = 3:
	set(value):
		# Snake must always have a head, body and tail
		if size < 3: return
		
		size = value
		tick_speed = DEFAULT_TICK_SPEED - clamp(size * 0.15, .1, .75)

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

## Initial tick speed, used as base for decrements
const DEFAULT_TICK_SPEED: float = 1

## Interval in seconds in which the snake moves
var tick_speed: float = DEFAULT_TICK_SPEED:
	set(value):
		tick_speed = value
		$Tick.start(value)

## Tiles occupied by the snake, first index is tail, last one is head
var snake_tiles: Array[Dictionary] = [
	{'pos': Vector2i(-2,0), 'rot': Vector2i(1,0)},
	{'pos': Vector2i(-1,0), 'rot': Vector2i(1,0)},
	{'pos': Vector2i(0,0), 'rot': Vector2i(1,0)},
]

## Snake's head direction, defines where
## it will go during the next tick, 
## basically, the last valid input from the player
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
var alive: bool = true:
	set(value):
		if value == false:
			died.emit()
		alive = value

func _process(_delta: float) -> void:
	# Feeds input vector directly to variable, check setter for requirements
	snake_direction = Input.get_vector("left", "right", "up", "down")

## Starts the tick system
func _ready() -> void:
	$Tick.start(tick_speed)

## Snake moves on a tick-based system
## During its death, it ticks one last time in order to update the sprite, but doesn't
## actually move
func _on_tick_timeout() -> void:
	
	# Only move snake if alive
	if alive:
		snake_tiles.append({
			'pos': snake_tiles[snake_tiles.size() - 1].pos + snake_direction,
			'rot': snake_direction
		})
	
	# Move head collider
	$Head.position = snake_tiles[snake_tiles.size()-1].pos * 16
	
	# Erase old tail position (if not grown in last tick)
	if snake_tiles.size() > size:
		set_cell(snake_tiles.pop_front().pos)
	
	# Check for collision with body
	for i in range(snake_tiles.size()-1):
		if snake_tiles[i].pos == snake_tiles[snake_tiles.size()-1].pos:
			alive = false
		
	# Update sprite
	for i in range(snake_tiles.size()):
		var current_tile: Dictionary = snake_tiles[i]
		var next_tile = snake_tiles[i+1] if i < snake_tiles.size()-1 else null
		var atlas_coords: Vector2i = Vector2i(0,0)
	
		# Define atlas Y coords (curve/tail/body/head sprite)
		# Is tail?
		if i == 0:
			# Tail
			atlas_coords.y = 1
		else:
			# Is body?
			if i < snake_tiles.size()-1:
				# Is turning?
				if current_tile.rot != next_tile.rot:
					# Curve body
					atlas_coords.y = 0
				else:
					# Body
					atlas_coords.y = 2
			else:
				# Head
				atlas_coords.y = 3
		
		# Define atlas X coords (rotation)
		match atlas_coords.y:
			# Curve
			0:
				# Get correct sprite based on possible "from->to" rotations
				var index: int = 0
				for target_coord in CURVE_ROTATION_DATA:
					for target_coord_item in target_coord:
						if current_tile.rot == target_coord_item[0] and next_tile.rot == target_coord_item[1]:
							atlas_coords.x = index
					index += 1
			
			# Tail
			1:
				atlas_coords.x = abs(
					(next_tile.rot.x + next_tile.rot.y * 2 + 1)
				 	% 4
				)
			
			# Body
			2:
				atlas_coords.x = abs(
					(current_tile.rot.x + current_tile.rot.y * 2 + 1)
					% 4
				)
			
			# Head
			3:
				atlas_coords.x = abs(
					(current_tile.rot.x + current_tile.rot.y * 2 + 1)
					% 4
				)
				
				# if dead, increment X by 4 to get "dead" sprite variant
				atlas_coords.x = atlas_coords.x + 4 if not alive else atlas_coords.x
				
		# Update tile
		set_cell(current_tile.pos, 0, atlas_coords)

	# Stop ticking if no longer alive
	if not alive:
		$Tick.stop()
