extends TileMap

var actor = preload("res://Nodes/actor_static.tscn")
var city = preload("res://Nodes/city.tscn")
var explotation = preload("res://Nodes/explotation.tscn")
var factory = preload("res://Nodes/factory.tscn")
var warehouse = preload("res://Nodes/warehouse.tscn")
var depot = preload("res://Nodes/depot.tscn")
var harbor = preload("res://Nodes/harbor.tscn")

var vehicle = preload("res://Nodes/vehicle.tscn")
var truck = preload("res://Nodes/truck.tscn")

const priority_queue_class = preload("res://Nodes/PriorityQueue.gd")

const iso_dirs = [ #this has to be corrected adding + Vector2i(0, x % 2)
		Vector2i(-1, -1),	# Top-left
		Vector2i(+1, -1),	# Top-right
		Vector2i(-1, 0),	# Bottom-left
		Vector2i(+1, 0)		# Bottom-right
	]

enum Layers {BASE, PATH, PREVIEW, ACTOR_STATIC, VEHICLE}

enum BuildMode { NONE, BUILDING, DEMOLISH, PATH, DEMOLISH_PATH }
enum BuildTypes { NONE, FACTORY, WAREHOUSE, DEPOT_ROAD, DEPOT_RAILWAY}
enum PathTypes { NONE = 99, ROAD = 0, RAILWAY = 1}

var map_width = 0
var map_height = 0

var occupied_tiles : Dictionary = {}

var mouse_tile : Vector2i
var mouse_tile_prev : Vector2i

var build_mode = BuildMode.NONE
var selected_building : Actor_Static
var selected_path : int

var start_tile #: Vector2i
var start_hold : Vector2i

const HUE_GREEN_T = '#00ff007f'
const HUE_RED_T = '#ff00007f'
const HUE_RED = '#ff0000ff'
const HUE_DEFAULT = '#ffffffff'

var debug_enabled : bool = false

var explotation_type_catalog : ExplotationTypeCatalog

signal forwarded_actor_static_clicked

# Called when the node enters the scene tree for the first time.
func _ready():
	explotation_type_catalog = load(Constants.EXPLOTATION_TYPE_CATALOG_PATH) as ExplotationTypeCatalog
	#map_width = 16
	#map_height = 16
	
	if get_parent() is Window:
		print_debug('Manual initialization')
		var city_inst = city.instantiate()
		add_child(city_inst)
		place_actor_static(city_inst, Vector2i(8, 8))
		
		var city_inst2 = city.instantiate()
		add_child(city_inst2)
		place_actor_static(city_inst2, Vector2i(10, 6))
		
		var city_inst3 = city.instantiate()
		add_child(city_inst3)
		place_actor_static(city_inst3, Vector2i(6, 10))
		
		#initialize(64, 64, 5, 2, 2)
	
	#if get_viewport() is SubViewport:
		#get_viewport().gui_disable_input = false
	#
	pass

func initialize(width : int, height : int, n_cities : int, n_explotations : int, n_harbors : int):
	map_width = width
	map_height = height
	generate_map(map_width, map_height)
	generate_actors_static(city, n_cities)
	generate_actors_static(explotation, n_explotations)
	generate_actors_static(harbor, n_harbors)
	generate_roads()
	#initialize_camera()
	
	#var truck_instance = truck.instantiate()
	#add_child(truck_instance)
	#truck_instance.z_index = Layers.VEHICLE
	#truck_instance.position = map_to_local(Vector2i(16, 16))
	
	#var vehicle_instance = vehicle.instantiate()
	#add_child(vehicle_instance)
	#var vehicle_model_catalog = load(Constants.VEHICLE_MODEL_CATALOG_PATH) as VehicleModelCatalog
	#vehicle_instance.initialize(vehicle_model_catalog.get_vehicle_model(1))
	#vehicle_instance.z_index = Layers.VEHICLE
	#vehicle_instance.position = map_to_local(Vector2i(4, 24))

func _process(_delta):
	$CursorLabel.visible = debug_enabled
	if debug_enabled:
		var world_pos = get_global_mouse_position()
		var map_pos = local_to_map(world_pos)
		$CursorLabel.z_index = Layers.PREVIEW
		$CursorLabel.position = get_global_mouse_position()
		$CursorLabel.text = "Tile Coordinates: (" + str(map_pos.x) + ", " + str(map_pos.y + 1) + ")\n" + \
							"Global Position: (" + str(roundf(world_pos.x)) + ", " + str(roundf(world_pos.y)) + ")"
	
	mouse_tile_prev = mouse_tile
	mouse_tile = local_to_map(get_global_mouse_position())
	if build_mode != BuildMode.NONE:
		match build_mode:
			BuildMode.BUILDING:
				if selected_building:
					selected_building.position = map_to_local(mouse_tile)
					if valid_position(floor(selected_building.position.x), floor(selected_building.position.y)):
						selected_building.sprite.self_modulate = HUE_GREEN_T
					else:
						selected_building.sprite.self_modulate = HUE_RED_T
						
			BuildMode.PATH:
				clear_layer(Layers.PREVIEW)
				if !start_tile:
					set_cells_terrain_connect(Layers.PREVIEW, [mouse_tile], 0, selected_path)
				else:
					var road_end = local_to_map(get_global_mouse_position())
					var path = construct_path(start_tile, road_end)
					set_cells_terrain_connect(Layers.PREVIEW, path, 0, selected_path)
			
			BuildMode.DEMOLISH:
				if occupied_tiles.has(mouse_tile_prev):
					occupied_tiles.get(mouse_tile_prev).sprite.self_modulate = HUE_DEFAULT
				if occupied_tiles.has(mouse_tile):
					occupied_tiles.get(mouse_tile).sprite.self_modulate = HUE_RED
			
			BuildMode.DEMOLISH_PATH:
				if !start_tile:
					pass
				else:
					pass

# INITIALIZATION FUNCTIONS

func generate_map(width : int, height : int):
	map_width = width
	map_height = height
	for x in range (width):
		for y in range (floor(height/2)):
			set_cell(Layers.BASE, Vector2i(x, y), 1, Vector2i(0, 3))

func generate_actors_static(actor_static_class, n : int):
	for i in range(n):
		var actor_static_instance = actor_static_class.instantiate()
		add_child(actor_static_instance)
		if actor_static_class == explotation:
			var type = explotation_type_catalog.get_random_explotation_type()
			actor_static_instance.initialize(type)
		place_actor_static(actor_static_instance)

func generate_roads(start_pos : Vector2i = Vector2i(-1, -1), end_pos : Vector2i = Vector2i(-1, -1)) :
	if start_pos == Vector2i(-1, -1):
		start_pos = occupied_tiles.keys()[0]
	if end_pos == Vector2i(-1, -1):
		end_pos = occupied_tiles.keys()[1]
	var path = a_star_search(start_pos, end_pos)
	set_cells_terrain_path(Layers.PATH, path, 0, 0)

#func initialize_camera():
	#var center_x = (self.tile_set.tile_size.x * map_width) / 2
	#var center_y = (self.tile_set.tile_size.y * map_height) / 2
	## We have to half the center position because the camera itself is not centered, but anchored to the top_left corner
	#$camera.set_starting_position(Vector2i(center_x / 2, center_y / 2))

# PLACING FUNCTIONS

func place_actor_static(actor_static_instance : Actor_Static, pos : Vector2i = Vector2i(-1, -1)) -> bool:
	if pos == Vector2i(-1, -1):
		pos = get_random_pos()
	if valid_position(pos.x, pos.y):
		actor_static_instance.z_index = Layers.ACTOR_STATIC
		actor_static_instance.position = map_to_local(pos)
		set_cell(Layers.PATH, pos, 1, Vector2i(1, 3))
		occupied_tiles[pos] = actor_static_instance
		actor_static_instance.connect("actor_static_clicked", Callable(self, "_on_actor_static_clicked"))
		return true
	else:
		return false

#func place_vehicle(vehicle_instance : Vehicle, pos : Vector2i):
	#vehicle_instance.position = pos

func create_vehicle(vehicle_model : VehicleModel, depot : Depot):
	var vehicle_instance = vehicle.instantiate()
	add_child(vehicle_instance)
	vehicle_instance.initialize(vehicle_model)
	vehicle_instance.z_index = Layers.VEHICLE
	vehicle_instance.position = depot.position
	depot.add_vehicle(vehicle_instance)

func delete_vehicle(index : int, depot : Depot):
	depot.remove_vehicle(index).queue_free.call_deferred()
	#vehicle.queue_free.call_deferred()

# BUILDING FUNCTIONS

func preview_building(actor_static_instance : Actor_Static):
	if selected_building:
		remove_child(selected_building)
	selected_building = actor_static_instance
	add_child(selected_building)
	selected_building.z_index = Layers.ACTOR_STATIC


func construct_path(start : Vector2i, end : Vector2i):
	var current : Vector2i = start
	var next : Vector2i
	var path = []
	path.append(current)
	while current != end:
		var min_d = Constants.MAX_INT
		for neighbour in get_iso_neighbours(current):
			var v_distance = end - (current + neighbour)
			var distance = abs(v_distance.x) + abs(v_distance.y)
			if distance < min_d:
				min_d = distance
				next = current + neighbour
		path.append(next)
		current = next
		
	path.append(end)
	return path

# CONSTRUCTION MENU BUTTONS HANDLING
func _on_construction_button_clicked(const_button : Constants.ConstButtons):
	match const_button:
		Constants.ConstButtons.FACTORY:
			build(BuildTypes.FACTORY)
		Constants.ConstButtons.WAREHOUSE:
			build(BuildTypes.WAREHOUSE)
		Constants.ConstButtons.DEPOT_ROAD:
			build(BuildTypes.DEPOT_ROAD)
		Constants.ConstButtons.DEPOT_RAILWAY:
			build(BuildTypes.DEPOT_RAILWAY)
		Constants.ConstButtons.ROAD:
			build_path(PathTypes.ROAD)
		Constants.ConstButtons.RAILWAY:
			build_path(PathTypes.RAILWAY)
		Constants.ConstButtons.DEMOLISH:
			set_build_mode(BuildMode.DEMOLISH)
		Constants.ConstButtons.DEMOLISH_PATH:
			set_build_mode(BuildMode.DEMOLISH_PATH)

# BUILD MODE FUNCTIONS
func build (build_type : BuildTypes):
	var building : Actor_Static
	match build_type:
		BuildTypes.NONE:
			printerr('Building different than BuildTypes.NONE required')
			return
		BuildTypes.FACTORY:
			building = factory.instantiate()
		BuildTypes.WAREHOUSE:
			building = warehouse.instantiate()
		BuildTypes.DEPOT_ROAD:
			building = depot.instantiate()
		BuildTypes.DEPOT_RAILWAY:
			printerr('Train depot not implemented yet')
	if building:
		set_build_mode(BuildMode.BUILDING)
		preview_building(building)

func build_path (path_type : PathTypes):
	if path_type == PathTypes.NONE:
		printerr('Building different than BuildTypes.NONE required')
	else:
		set_build_mode(BuildMode.PATH)
		selected_path = path_type

func set_build_mode(new_build_mode : BuildMode) :
	print_debug('Changing Build Mode')
	# REMOVE PREVIOUS MODE
	match build_mode:
		BuildMode.NONE:
			pass
		BuildMode.BUILDING:
			if selected_building:
				remove_child(selected_building)
			selected_building = null
		BuildMode.PATH:
			start_tile = null
			clear_layer(Layers.PREVIEW)
		BuildMode.DEMOLISH:
			if occupied_tiles.has(mouse_tile):
				occupied_tiles.get(mouse_tile).sprite.self_modulate = HUE_DEFAULT
		BuildMode.DEMOLISH_PATH:
			pass
	
	#SET NEW BUILD MODE
	match new_build_mode:
		BuildMode.NONE:
			pass
		BuildMode.BUILDING:
			pass
		BuildMode.PATH:
			pass
		BuildMode.DEMOLISH:
			pass
		BuildMode.DEMOLISH_PATH:
			pass
	
	build_mode = new_build_mode


func lay_road(path):
		for tile in path:
			if occupied_tiles.has(tile):
				path.erase(tile)
		set_cells_terrain_connect(Layers.PATH, path, 0, selected_path)

func demolish(pos : Vector2i):
	if occupied_tiles.has(pos):
		var building = occupied_tiles.get(pos)
		if building.is_demolishable():
			#remove_child(building)
			building.queue_free.call_deferred()
			set_cell(Layers.PATH, pos, -1)
			occupied_tiles.erase(pos)

func demolish_road(pos : Vector2i):
	if !occupied_tiles.has(pos):
		set_cell(Layers.PATH, pos, -1) # TRY TO CORRECT THE MISCONECTIONS AROUND

# UTILITIES

func get_random_pos() -> Vector2i:
	var rand_x = -1
	var rand_y = -1
	while(!valid_position(rand_x, rand_y)):
		rand_x = randi() % map_width
		rand_y = randi() % (map_height / 2)
	return Vector2i(rand_x, rand_y)

func valid_position(x : int, y : int) -> bool :
	if occupied_tiles.has(Vector2i(x, y)):
		return false
	return x > -1 and y > -1

func get_iso_neighbours(pos : Vector2i) :
	var mod = pos.x % 2
	var neighbours = [
		Vector2i(-1, mod -1),	# Top-left
		Vector2i(+1, mod -1),	# Top-right
		Vector2i(-1, mod),		# Bottom-left
		Vector2i(+1, mod)		# Bottom-right
	]
	return neighbours

func calculate_area_corners(pos1 : Vector2i, pos2 : Vector2i) -> Array[Vector2i]:
	var x0 # Top-left corner
	var y0 # Top-left corner
	var x1 # Bottom-right corner
	var y1 # Bottom-right corner
	if pos1.x > pos2.x:
		x1 = pos2.x
		x0 = pos1.x
	else:
		x0 = pos1.x
		x1 = pos2.x
		
	if pos1.y > pos2.y:
		y1 = pos2.y
		y0 = pos1.y
	else:
		y0 = pos1.y
		y1 = pos2.y
	
	var top_left_corner : Vector2i = Vector2i(x0, y0)
	var bottom_right_corner : Vector2i = Vector2i(x1, y1)
	
	return [top_left_corner, bottom_right_corner]

# INPUT_HANDLERS

func _on_actor_static_clicked(actor_static_id : int):
	print_debug('Forwarding')
	emit_signal("forwarded_actor_static_clicked", actor_static_id)

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_ESCAPE:
				if build_mode != BuildMode.NONE:
					set_build_mode(BuildMode.NONE)
				else:
					#get_tree().quit()
					pass
			if event.keycode == KEY_K:
				debug_enabled = !debug_enabled
				print("Debug mode: " + ['disabled', 'enabled'][int(debug_enabled)])
			if event.keycode == KEY_C:
				for child in get_children():
					if child is Actor_Static:
						print(child.get_class)
			if event.keycode == KEY_O:
				for tile in occupied_tiles:
					print('Structure: ' + str(occupied_tiles.get(tile)) + ', Position: ' + str(tile))
			if event.keycode == KEY_M:
				print('Building Mode: ' + str(build_mode))

	if event is InputEventMouseButton and event.pressed:
		# NOT VERY ELEGANT, BUT FOR SOME REASON, INPUT WAS NOT PROPAGATING RIGHT
		#for child in self.get_children():
			##print(str(child.name))
			#if child is Actor_Static:
				#child._gui_input(event)
		print_debug('Click detected on MAP')
		if event.button_index == MOUSE_BUTTON_LEFT:
			if build_mode != BuildMode.NONE:
				#var pos = local_to_map(get_global_mouse_position())
				match build_mode:
					BuildMode.BUILDING:
						if selected_building:
							selected_building.sprite.self_modulate = HUE_DEFAULT
							var placed = place_actor_static(selected_building, mouse_tile)
							if placed: # COULD BE PREVIEW A NEW BUILDING
								selected_building = null
							set_build_mode(BuildMode.NONE)
							
					BuildMode.PATH:
						if !start_tile:
							start_tile = mouse_tile
						else:
							var end_tile = mouse_tile
							var path = construct_path(start_tile, end_tile)
							lay_road(path)
							start_tile = end_tile
					BuildMode.DEMOLISH:
						demolish(mouse_tile)
						set_build_mode(BuildMode.NONE)
					BuildMode.DEMOLISH_PATH:
						demolish_road(mouse_tile)
			else:
				var tile_clicked = local_to_map(get_global_mouse_position())
				if occupied_tiles.has(tile_clicked):
					var e = occupied_tiles.get(tile_clicked)
					print_debug('Forwarding from input handler')
					emit_signal("forwarded_actor_static_clicked", e.get_instance_id())
				

		if event.button_index == MOUSE_BUTTON_RIGHT:
			if build_mode == BuildMode.PATH and start_tile:
				start_tile = null
			else:
				set_build_mode(BuildMode.NONE)
	#print(str(event))





# A* Algorithm PENDING IMPROVEMENTS TO GENERATE STRAIGHT ROADS MORE OFTEN

func a_star_search(start, goal):
	var open_set = priority_queue_class.new()
	open_set.push(start, 0)

	var came_from = {}
	var cost_so_far = {}
	var last_dir = {}
	came_from[start] = null
	cost_so_far[start] = 0
	last_dir[start] = null

	while not open_set.empty():
		var current = open_set.pop()
		if current == goal:
			break

		for next in get_neighbors(current):
			var direction = calc_dir(current, next)
			var new_cost = cost_so_far[current] + movement_cost(current, next, last_dir[current], direction)
			if current.y < 12 and current.y > 5:
				pass
				#print('Current: ' + str(current) + ', Next: ' + str(next) + ', Cost: ' + str(movement_cost(current, next, last_dir[current], direction)) + ', New_dir: ' + str(direction != last_dir[current]))
			if direction == last_dir[current]:
				pass
				#print('Current: ' + str(current) + ', Next: ' + str(next) + ', New_dir: ' + str(direction != last_dir[current]))
			
			if not cost_so_far.has(next) or new_cost < cost_so_far[next]:
				cost_so_far[next] = new_cost
				var priority = new_cost + heuristic(goal, next, last_dir[current], direction)
				open_set.push(next, priority)
				came_from[next] = current
				last_dir[next] = direction
				#print('Current: ' + str(current) + ', Next: '+ str(next) + ', Priority: ' + str(priority) + ', Heuristic: ' + str(heuristic(goal, next, last_dir[current], direction)) + ', Cost so far: ' + str(cost_so_far[next]))

	return reconstruct_path(came_from, start, goal)


func get_neighbors(node : Vector2i):
	var mod = node.x % 2
	var neighbors = []
	
	var directions = [
		Vector2i(-1, mod -1),	# Top-left
		Vector2i(+1, mod -1),	# Top-right
		Vector2i(-1, mod),		# Bottom-left
		Vector2i(+1, mod)		# Bottom-right
	]

	for dir in directions:
		var neighbor = node + dir
		if is_valid_position(neighbor):
			neighbors.append(neighbor)
	return neighbors

func calc_dir(current : Vector2i, next : Vector2i) -> Vector2i :
	var x_dir = next.x - current.x
	var y_dir = next.y - current.y
	var mod = (current.x % 2) * x_dir
	return Vector2i(x_dir, y_dir + mod)

func movement_cost(_from, _to, last_dir, dir):
	var cost = 10 #MOVE_COST
	if dir != last_dir: cost += 5
	return cost


func heuristic(a, b, last_dir, dir):
	var h = abs(a.x - b.x) + abs(a.y - b.y)
	if dir != last_dir: h += 5
	return h


func reconstruct_path(came_from, start, goal):
	var current = goal
	var path = [current]
	while current != start:
		current = came_from[current]
		path.append(current)

	path.reverse()
	return path


func is_valid_position(pos):
	return pos.x >= 0 and pos.y >= 0 and pos.x < map_width and pos.y < map_height
	



