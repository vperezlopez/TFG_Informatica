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
		Vector2i(-1, 0),		# Bottom-left
		Vector2i(+1, 0)		# Bottom-right
	]

enum PATH {ROAD = 1, RAILWAY = 2}
enum BuildMode { NONE, BUILDING, DEMOLISH, ROAD, DEMOLISH_ROAD }

var map_width = 0
var map_height = 0

var occupied_tiles : Dictionary = {}

var b_mode : BuildMode = BuildMode.NONE

var mouse_tile : Vector2i
var mouse_tile_prev : Vector2i

var start_tile #: Vector2i
var start_hold : Vector2i

var selected_building : Actor_Static

const HUE_GREEN_T = '#00ff007f'
const HUE_RED_T = '#ff00007f'
const HUE_RED = '#ff0000ff'
const HUE_DEFAULT = '#ffffffff'

var debug_enabled : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func initialize(width : int, height : int, n_cities : int, n_explotations : int, n_harbors : int):
	map_width = width
	map_height = height
	generate_map(map_width, map_height)
	generate_actors_static(city, n_cities)
	generate_actors_static(explotation, n_explotations)
	generate_actors_static(harbor, n_harbors)
	generate_roads()
	
	var truck_instance = truck.instantiate()
	add_child(truck_instance)
	truck_instance.z_index = 3
	truck_instance.position = map_to_local(Vector2i(16, 16))
	


func _process(_delta):
	$CursorLabel.visible = debug_enabled
	if debug_enabled:
		var world_pos = get_global_mouse_position()
		var map_pos = local_to_map(world_pos)
		$CursorLabel.z_index = 2
		$CursorLabel.position = get_global_mouse_position()
		$CursorLabel.text = "Tile Coordinates: (" + str(map_pos.x) + ", " + str(map_pos.y + 1) + ")\n" + \
							"Global Position: (" + str(roundf(world_pos.x)) + ", " + str(roundf(world_pos.y)) + ")"
	
	mouse_tile_prev = mouse_tile
	mouse_tile = local_to_map(get_global_mouse_position())
	if b_mode != BuildMode.NONE:
		match b_mode:
			BuildMode.BUILDING:
				if selected_building:
					selected_building.position = map_to_local(mouse_tile)
					if valid_position(floor(selected_building.position.x), floor(selected_building.position.y)):
						selected_building.sprite.self_modulate = HUE_GREEN_T
					else:
						selected_building.sprite.self_modulate = HUE_RED_T
						
			BuildMode.ROAD:
				clear_layer(2)
				if !start_tile:
					set_cells_terrain_connect(2, [mouse_tile], 0, 0)
				else:
					var road_end = local_to_map(get_global_mouse_position())
					var path = construct_path(start_tile, road_end)
					set_cells_terrain_connect(2, path, 0, 0)
			
			BuildMode.DEMOLISH:
				if occupied_tiles.has(mouse_tile_prev):
					occupied_tiles.get(mouse_tile_prev).sprite.self_modulate = HUE_DEFAULT
				if occupied_tiles.has(mouse_tile):
					occupied_tiles.get(mouse_tile).sprite.self_modulate = HUE_RED
			
			BuildMode.DEMOLISH_ROAD:
				if !start_tile:
					pass
				else:
					pass

# GENERATION FUNCTIONS

func generate_map(width : int, height : int):
	map_width = width
	map_height = height
	for x in range (width):
		for y in range (floor(height/2)):
			set_cell(0, Vector2i(x, y), 1, Vector2i(0, 3))

func generate_actors_static(actor_static_class, n : int):
	for i in range(n):
		var static_actor_instance = actor_static_class.instantiate()
		add_child(static_actor_instance)
		place_actor_static(static_actor_instance)

func generate_roads(start_pos : Vector2i = Vector2i(-1, -1), end_pos : Vector2i = Vector2i(-1, -1)) :
	if start_pos == Vector2i(-1, -1):
		start_pos = occupied_tiles.keys()[0]
	if end_pos == Vector2i(-1, -1):
		end_pos = occupied_tiles.keys()[1]
	var path = a_star_search(start_pos, end_pos)
	draw_roads(path)


# PLACING FUNCTIONS

func place_actor_static(actor_static_instance : Actor_Static, pos : Vector2i = Vector2i(-1, -1)):
	if pos == Vector2i(-1, -1):
		pos = get_random_pos()
	if valid_position(pos[0], pos[1]):
		actor_static_instance.z_index = 3
		actor_static_instance.position = map_to_local(pos)
		occupied_tiles[pos] = actor_static_instance

func draw_roads(path):
	set_cells_terrain_path(1, path, 0, 0)


# BUILDING FUNCTIONS

func preview_building(actor_static_instance : Actor_Static):
	if selected_building:
		remove_child(selected_building)
	selected_building = actor_static_instance
	add_child(selected_building)
	selected_building.z_index = 3


func build_actor_static(actor_static_instance : Actor_Static) -> bool:
	var pos = local_to_map(get_global_mouse_position())
	var valid = valid_position(pos.x, pos.y)
	if valid:
		place_actor_static(actor_static_instance, pos)
	return valid

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

func set_build_mode(bm : BuildMode) :
	
	# REMOVE PREVIOUS MODE
	match b_mode:
		BuildMode.NONE:
			pass
		BuildMode.BUILDING:
			if selected_building:
				remove_child(selected_building)
			selected_building = null
		BuildMode.ROAD:
			start_tile = null
			clear_layer(2)
		BuildMode.DEMOLISH:
			if occupied_tiles.has(mouse_tile):
				occupied_tiles.get(mouse_tile).sprite.self_modulate = HUE_DEFAULT
		BuildMode.DEMOLISH_ROAD:
			pass
	
	#SET NEW BUILD MODE
	match bm:
		BuildMode.NONE:
			pass
		BuildMode.BUILDING:
			pass
		BuildMode.ROAD:
			pass
		BuildMode.DEMOLISH:
			pass
		BuildMode.DEMOLISH_ROAD:
			pass
	
	b_mode = bm

func build(pos : Vector2i, actor_static_instance : Actor_Static):
	pass
	
func build_road(pos : Vector2i):
	if !start_tile:
		start_tile = pos
	else:
		var end_tile = pos
		var path = construct_path(start_tile, end_tile)
		set_cells_terrain_connect(1, path, 0, 0)
		start_tile =end_tile

func demolish(pos : Vector2i):
	if occupied_tiles.has(pos):
		remove_child(occupied_tiles.get(pos))
		occupied_tiles.erase(pos)

func demolish_road(pos : Vector2i):
	set_cell(1, pos, -1) # TRY TO CORRECT THE MISCONECTIONS AROUND

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

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_ESCAPE:
				if b_mode != BuildMode.NONE:
					set_build_mode(BuildMode.NONE)
				else:
					get_tree().quit()
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
				print('Building Mode: ' + str(b_mode))
			if event.keycode == KEY_F:
				set_build_mode(BuildMode.BUILDING)
				preview_building(factory.instantiate())
			if event.keycode == KEY_D:
				set_build_mode(BuildMode.BUILDING)
				preview_building(depot.instantiate())
			if event.keycode == KEY_W:
				set_build_mode(BuildMode.BUILDING)
				preview_building(warehouse.instantiate())
			if event.keycode == KEY_R:
				set_build_mode(BuildMode.ROAD)
			if event.keycode == KEY_X:
				set_build_mode(BuildMode.DEMOLISH)
			if event.keycode == KEY_Z:
				set_build_mode(BuildMode.DEMOLISH_ROAD)
				
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			match b_mode:
				BuildMode.BUILDING:
					if selected_building:
						selected_building.sprite.self_modulate = HUE_DEFAULT
						var placed = build_actor_static(selected_building)
						if !placed: # CHECK WHY THIS LOGIC WORKS
							#cancel_building_mode()
							set_build_mode(BuildMode.NONE)
						selected_building = null
				BuildMode.ROAD:
					build_road(mouse_tile)
				BuildMode.DEMOLISH:
					demolish(mouse_tile)
				BuildMode.DEMOLISH_ROAD:
					demolish_road(mouse_tile)

		if event.button_index == MOUSE_BUTTON_RIGHT:
			if b_mode == BuildMode.ROAD and start_tile:
				start_tile = null
			else:
				set_build_mode(BuildMode.NONE)























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
	



