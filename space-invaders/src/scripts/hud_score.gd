extends Label

func _ready():
	text = "SCORE: %s" % G.current_score
	G.score_updated.connect(_on_score_updated)
		
func _on_score_updated(value: int):
	text = "SCORE: %s" % value