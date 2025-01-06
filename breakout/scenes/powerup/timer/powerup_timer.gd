class_name PowerupTimer
extends Timer

var powerup_id: int

func _enter_tree() -> void:
	match powerup_id:
		G.powerup.FIREBALL: wait_time = 5
		G.powerup.SPEEDUP: wait_time = 20
	start()

func _ready() -> void:
	match powerup_id:
		G.powerup.ONE_UP:
			get_node("../../%LivesUI").add_lives.emit(1)
			$"1UpCollect".play()
			await $"1UpCollect".finished
	
	if powerup_id <= 0:
		queue_free()

func _on_timeout() -> void:
	match powerup_id:
		G.powerup.FIREBALL:
			var ball = get_node_or_null("../../Ball")
			if ball:
				ball.fireball = false
		G.powerup.SPEEDUP:
			var player = get_parent()
			player.move_speed = player.base_move_speed
	queue_free()
