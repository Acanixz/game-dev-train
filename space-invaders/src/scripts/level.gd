class_name Level
extends Node2D

## Player instantly game overs if troops get too close
func _on_troop_moved_down() -> void:
	if $Troop.get_bottom_position() >= $Player.global_position.y - $Troop.spacing.y:
		$Player.lives = 1
		$Player.died.emit()
