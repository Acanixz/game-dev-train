class_name UFO
extends Invader

const BASE_VELOCITY: float = 70

var velocity: float = BASE_VELOCITY
var direction: int = 1

## Constant movement in the target direction
func _physics_process(delta: float) -> void:
	position = position + (Vector2(velocity, 0) * delta) * direction

## Constantly plays the alert sound while alive
func _on_alert_sound_finished() -> void:
	G.random_pitch_and_play($AlertSound)

## Delete itself after leaving the screen
func _on_visibility_screen_exited() -> void:
	queue_free()
