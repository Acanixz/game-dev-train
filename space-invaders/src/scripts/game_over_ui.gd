extends Control

signal triggered

func _ready() -> void:
	triggered.connect(_on_triggered)
	
func _on_triggered():
	if G.current_score > G.high_scores[0].score:
		$HighScore.visible = true