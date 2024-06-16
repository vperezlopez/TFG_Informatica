extends Actor_Static

class_name City

@export var population : int

func _ready():
	super._ready()
	demolishable = false
	sprite.texture = preload("res://Assets/Buildings/City.png")
	loc_name = Utils.random_city_name()
	label.text = loc_name
	
	population = randi()

