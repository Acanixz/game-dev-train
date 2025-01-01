extends Label

var score: int = 0
signal add_score(increment: int)

func _on_add_score(increment: int) -> void:
	score += increment
	text = "Score: %s" % score
