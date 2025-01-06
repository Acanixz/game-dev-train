extends Node2D

const BALL_SCENE = preload("res://scenes/ball/ball.tscn")

func change_level(new_id):
	if G.levels.size() >= new_id:
		# Delete old map
		var old_tilemap = get_node("TileMap") 
		remove_child(old_tilemap)
		old_tilemap.queue_free()
		
		# Load new map and prepare
		%LevelCompleted.visible = false
		add_child(load(G.levels[new_id-1]).instantiate(), true)
		add_child(BALL_SCENE.instantiate(), true)
	else:
		print("Could not load map because the map ID %s does not exist" % new_id)
		change_level(1)
