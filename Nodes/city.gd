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

func unload_cargo(cargo : Cargo, quantity : int) -> int:
	var earnings : float = cargo.value * quantity
	print('You earned: ' + str(earnings))
	return quantity


#func unload_cargo(cargo : Cargo, quantity : int) -> int:
	#print_debug("This building does not accept cargo: " + str(self.get_class()))
	#return -1
#
#func load_cargo(cargo : Cargo, quantity : int) -> int:
	#print_debug("This building does not offer cargo: " + str(self.get_class()))
	#return -1
