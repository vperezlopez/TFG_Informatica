extends Actor_Static

class_name Depot

var fleet : Array[Vehicle]
var capacity : int

func _ready():
	super._ready()
	demolishable = true
	sprite.texture = preload("res://Assets/Placeholder_5.png")
	
	fleet = []
	capacity = 9

func add_vehicle(vehicle : Vehicle):
	if fleet.size() >= capacity:
		printerr('Depot at max capacity.')
	else:
		fleet.append(vehicle)

func remove_vehicle(index : int) -> Vehicle:
	return fleet.pop_at(index)


#func add_vehicle(vehicle : Vehicle):
	#if fleet.size() >= capacity:
		#printerr('Depot at max capacity.')
	#else:
		#fleet.append(vehicle)

#func _on_input_event(_viewport, event, _shape_idx):
	#if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		#open_menu()
#
#func open_menu():
	#pass
