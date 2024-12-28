extends Node2D

signal game_over(winner: Node2D)

func _on_game_over(winner: Node2D) -> void:
	%WinnerText.text = "%s wins!" % winner.name
	$WinnerScreen.visible = true
