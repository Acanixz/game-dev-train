extends Label

func _ready() -> void:
	if get_parent().scale.x < 0:
		self.scale.x *= -1
		self.global_position.x -= 50
