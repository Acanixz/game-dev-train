extends Label

func _ready() -> void:
	text = "HIGH-SCORE: %s" % G.high_scores[0].score