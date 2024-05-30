extends Actor_Static

class_name Explotation

func _ready():
	super._ready()
	sprite.texture = preload("res://Placeholder_1.png")

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		open_menu()

func open_menu():
	pass

