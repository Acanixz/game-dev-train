extends HBoxContainer

const LIFE_ICON = preload("res://resources/life_icon.tscn")
const BALL_SCENE = preload("res://scenes/ball/ball.tscn")

const MAX_LIVES = 5
var lives: int = 3

signal add_lives(increment: int)
signal remove_life()

func _on_add_lives(increment: int = 1) -> void:
	for i in range(increment):
		if lives >= MAX_LIVES: return
		
		lives += 1
		call_deferred("add_child", LIFE_ICON.instantiate())
		await get_tree().create_timer(.25).timeout

func _on_remove_life() -> void:
	if lives <= 0: return
	lives -= 1
	for child in get_children():
		if child is TextureRect:
			child.call_deferred("queue_free")
			break
	$Death.play()
	if lives < 1:
		%GameOver.get_node("Score").text = "Final Score: %s" % str(%ScoreLabel.score)
		%GameOver.visible = true
		return
	
	await get_tree().create_timer(1).timeout
	G.get_level_node().call_deferred("add_child", BALL_SCENE.instantiate(), true)
	G.get_level_node().get_node("Player").position.x = 0
