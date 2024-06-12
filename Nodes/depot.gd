extends Actor_Static

class_name Depot

func _ready():
	super._ready()
	demolishable = true
	sprite.texture = preload("res://Assets/Placeholder_5.png")

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		open_menu()

func open_menu():
	pass
