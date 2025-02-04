extends Node

@export var timer: float = 1

func _ready() -> void:
	await get_tree().create_timer(timer).timeout
	queue_free()