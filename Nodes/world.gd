extends Node2D

var actor = preload("res://Nodes/actor_static.tscn")
var city = preload("res://Nodes/city.tscn")
var explotation = preload("res://Nodes/explotation.tscn")
var factory = preload("res://Nodes/factory.tscn")
var warehouse = preload("res://Nodes/warehouse.tscn")
var depot = preload("res://Nodes/depot.tscn")
var harbor = preload("res://Nodes/harbor.tscn")

var map_width = 64 # *2
var map_height = 64 # /2

var n_cities = 0
var n_explotations = 0
var n_harbors = 0

var build : Actor_Static

# Called when the node enters the scene tree for the first time.
func _ready():
	var map = $map
	map.generate_map(map_width, map_height)
	generate_cities(n_cities)
	generate_actors_static()
	
	var c1 = city.instantiate()
	var c2 = city.instantiate()
	add_child(c1)
	add_child(c2)
	$map.place_actor_static(c1, Vector2i(8, 8))
	$map.place_actor_static(c2, Vector2i(32, 8))
	map.generate_roads()
	
	for e in $map.occupied_tiles:
		var actor = $map.occupied_tiles.get(e)
		if actor is City: print('City')
		if actor is Explotation: print('Explotation')
		if actor is Harbor: print('Harbor')

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if build:
		build.position = get_global_mouse_position()
	pass

func generate_cities(n : int):
	for i in range(n):
		var city_instance = city.instantiate()
		add_child(city_instance)
		#$map.place_city_random(city_instance)
		$map.place_actor_static(city_instance)

func generate_actors_static():
	for i in range(n_explotations):
		var explotation_instance = explotation.instantiate()
		add_child(explotation_instance)
		$map.place_actor_static(explotation_instance)
	
	for i in range(n_harbors):
		var harbor_instance = harbor.instantiate()
		add_child(harbor_instance)
		$map.place_actor_static(harbor_instance)

func _on_control_gui_input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		print("Out click detected")
	pass # Replace with function body.

func building_mode(actor_static_instance : Actor_Static):
	print('Building mode: engaged')
	if build:
		remove_child(build)
	build = actor_static_instance
	add_child(build)

func cancel_building_mode():
	if build:
		remove_child(build)
	build = null

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_ESCAPE:
				get_tree().quit()
			if event.keycode == KEY_K:
				$map.debug_enabled = !$map.debug_enabled
				print("Debug mode: " + ['disabled', 'enabled'][int($map.debug_enabled)])
			if event.keycode == KEY_F:
				building_mode(factory.instantiate())
			if event.keycode == KEY_D:
				building_mode(depot.instantiate())
			if event.keycode == KEY_W:
				building_mode(warehouse.instantiate())
			if event.keycode == KEY_C:
				for child in get_children():
					print(child.get_class)
				
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if build:
				var placed = $map.build_actor_static(build)
				if !placed:
					cancel_building_mode()
				build = null

		if event.button_index == MOUSE_BUTTON_RIGHT:
			if build:
				cancel_building_mode()
