extends Button

@export var target_url: String = "https://google.com"

func _ready() -> void:
	pressed.connect(_on_pressed)
	
func _on_pressed():
	OS.shell_open(target_url)