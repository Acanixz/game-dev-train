class_name UiBtn
extends Button

## This button can switch visibility between two Control nodes,
## used for the menu screen

## This control node will be invisible when the button is pressed
@export var off_screen: Control

## This control node will be visible when the button is pressed
@export var on_screen: Control

func _ready() -> void:
	pressed.connect(_on_pressed)
	
func _on_pressed() -> void:
	if is_instance_valid(off_screen) and is_instance_valid(on_screen):
		off_screen.visible = false
		on_screen.visible = true