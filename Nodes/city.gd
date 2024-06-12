extends Actor_Static

class_name City

@export var population : int

func _ready():
	super._ready()
	demolishable = false
	sprite.texture = preload("res://Assets/Placeholder_2.png")
