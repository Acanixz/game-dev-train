extends Node

enum powerup {
	ONE_UP = -1,
	FIREBALL = 1,
	SPEEDUP = 2,
}

const MENU_SCENE = "res://scenes/menu/menu.tscn"
const GAME_SCENE = "res://scenes/level/level.tscn"
const levels = [
	"res://scenes/level/tilemaps/1.tscn",
	"res://scenes/level/tilemaps/2.tscn",
	"res://scenes/level/tilemaps/3.tscn",
	"res://scenes/level/tilemaps/4.tscn",
	"res://scenes/level/tilemaps/5.tscn",
]

func get_level_node():
	return get_tree().root.get_node("Level")

func get_level_tilemap():
	return get_level_node().get_node("TileMap")
