extends Node2D

var map_width = 64 # *2
var map_height = 64 # /2

var n_cities = 2
var n_explotations = 0
var n_harbors = 0

var map_class = preload("res://Nodes/map.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var map = map_class.instantiate()
	map.initialize(map_width, map_height, n_cities, n_explotations, n_harbors)
	add_child(map)
	
	
	
	
	#var map = $map
	#map.generate_map(map_width, map_height)
	#generate_cities(n_cities)
	#generate_actors_static()
	#
	#var c1 = city.instantiate()
	#var c2 = city.instantiate()
	#add_child(c1)
	#add_child(c2)
	#$map.place_actor_static(c1, Vector2i(8, 8))
	#$map.place_actor_static(c2, Vector2i(32, 8))
	#map.generate_roads()
	#
	#for e in $map.occupied_tiles:
		#var actor = $map.occupied_tiles.get(e)
		#if actor is City: print('City')
		#if actor is Explotation: print('Explotation')
		#if actor is Harbor: print('Harbor')

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func generate_cities(n : int):
	#for i in range(n):
		#var city_instance = city.instantiate()
		#add_child(city_instance)
		##$map.place_city_random(city_instance)
		#$map.place_actor_static(city_instance)
#
#func generate_actors_static():
	#for i in range(n_explotations):
		#var explotation_instance = explotation.instantiate()
		#add_child(explotation_instance)
		#$map.place_actor_static(explotation_instance)
	#
	#for i in range(n_harbors):
		#var harbor_instance = harbor.instantiate()
		#add_child(harbor_instance)
		#$map.place_actor_static(harbor_instance)

func _on_control_gui_input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		print("Out click detected")
	pass # Replace with function body.




