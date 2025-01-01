class_name Powerup
extends Area2D

const POWERUP_ICONS = {
	-1: "res://assets/images/1UP.png",
	1: "res://assets/images/fireball.png",
	2: "res://assets/images/speedup.png",
}
var powerup_timer_scene = preload("res://scenes/powerup/timer/powerup_timer.tscn")

@export var fall_speed: int = 90
@export var powerup_id: int = 0

func _ready() -> void:
	var POWERUP_TEXTURE = load(POWERUP_ICONS[powerup_id])
	$Sprite.texture = POWERUP_TEXTURE

func _physics_process(delta: float) -> void:
	position = Vector2(position.x, position.y + (fall_speed * delta))

func _on_body_entered(body: Node2D) -> void:
	if body.name == "DeathBounds":
		queue_free()
	
	if body is Player:
		var powerup_timer_instance: PowerupTimer = powerup_timer_scene.instantiate()
		powerup_timer_instance.powerup_id = powerup_id
		
		# Delete old timer for same powerup in order to extend duration
		for child in body.get_children():
			if child is PowerupTimer and child.powerup_id == powerup_id:
				child.call_deferred("queue_free")
				
		body.call_deferred("add_child", powerup_timer_instance)

		# Add effects
		match powerup_id:
			G.powerup.FIREBALL:
				var ball = get_node_or_null("../Ball")
				if ball:
					ball.fireball = true
			G.powerup.SPEEDUP: 
				body.move_speed = body.base_move_speed * 2
		
		queue_free()
