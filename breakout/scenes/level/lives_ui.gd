extends HBoxContainer

var res_life_icon = preload("res://resources/life_icon.tscn")
var ball_scene = preload("res://scenes/ball/ball.tscn")

const MAX_LIVES = 5
var lives: int = 3

signal add_lives(increment: int)
signal remove_life()

func _on_add_lives(increment: int = 1) -> void:
	for i in range(increment):
		if lives >= MAX_LIVES: return
		
		lives += 1
		call_deferred("add_child", res_life_icon.instantiate())
		await get_tree().create_timer(.25).timeout

func _on_remove_life() -> void:
	if lives <= 0: return
	lives -= 1
	get_child(1).call_deferred("queue_free")
	if lives < 1:
		print("Game over!")
		return
	
	await get_tree().create_timer(1).timeout
	get_tree().root.get_node("Level").call_deferred("add_child", ball_scene.instantiate(), true)
