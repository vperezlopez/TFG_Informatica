extends TileMap

var actor = preload("res://Nodes/actor_static.tscn")
var city = preload("res://Nodes/city.tscn")
var explotation = preload("res://Nodes/explotation.tscn")
var factory = preload("res://Nodes/factory.tscn")
var warehouse = preload("res://Nodes/warehouse.tscn")
var depot = preload("res://Nodes/depot.tscn")
var harbor = preload("res://Nodes/harbor.tscn")

const PriorityQueue = preload("res://Nodes/PriorityQueue.gd")

enum PATH {ROAD = 1, RAILWAY = 2}

var map_width = 0
var map_height = 0

var occupied_tiles : Dictionary = {}

var mouse_tile : Vector2i
var selected_building : Actor_Static
var debug_enabled : bool = false
var build_road : bool = false
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


func _process(delta):
	$CursorLabel.visible = debug_enabled
	if debug_enabled:
		var world_pos = get_global_mouse_position()
		var map_pos = local_to_map(world_pos)
		$CursorLabel.z_index = 2
		$CursorLabel.position = get_global_mouse_position()
		$CursorLabel.text = "Tile Coordinates: (" + str(map_pos.x) + ", " + str(map_pos.y + 1) + ")\n" + \
							"Global Position: (" + str(roundf(world_pos.x)) + ", " + str(roundf(world_pos.y)) + ")"
	
	mouse_tile = local_to_map(get_global_mouse_position())
	if selected_building:
		selected_building.position = map_to_local(mouse_tile)
		if !valid_position(selected_building.position.x, selected_building.position.y):
			selected_building.sprite.self_modulate = '#ff00007f'
		else:
			selected_building.sprite.self_modulate = '#00ff007f'
	
	if build_road:
		print('build road')
		print(mouse_tile)
		set_cell(2, mouse_tile, 2, Vector2i(3, 1))

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
		actor_static_instance.position = map_to_local(pos)
		occupied_tiles[pos] = actor_static_instance

func draw_roads(path):
	for pos in path:
		print(pos)
	set_cells_terrain_path(1, path, 0, 0)


# BUILDING FUNCTIONS

func building_mode(actor_static_instance : Actor_Static):
	if selected_building:
		remove_child(selected_building)
	selected_building = actor_static_instance
	add_child(selected_building)
	selected_building.z_index = 2

func cancel_building_mode():
	if selected_building:
		remove_child(selected_building)
	selected_building = null

func build_actor_static(actor_static_instance : Actor_Static) -> bool:
	var pos = local_to_map(get_global_mouse_position())
	var valid = valid_position(pos.x, pos.y)
	if valid:
		place_actor_static(actor_static_instance, pos)
	return valid

func building_mode_road():
	build_road = true

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



# INPUT_HANDLERS

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_ESCAPE:
				get_tree().quit()
			if event.keycode == KEY_K:
				debug_enabled = !debug_enabled
				print("Debug mode: " + ['disabled', 'enabled'][int(debug_enabled)])
			if event.keycode == KEY_F:
				building_mode(factory.instantiate())
			if event.keycode == KEY_D:
				building_mode(depot.instantiate())
			if event.keycode == KEY_W:
				building_mode(warehouse.instantiate())
			if event.keycode == KEY_C:
				for child in get_children():
					print(child.get_class)
			if event.keycode == KEY_R:
				print('Building road')
				building_mode_road()
				
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if selected_building:
				selected_building.sprite.self_modulate = '#ffffffff'
				var placed = build_actor_static(selected_building)
				if !placed:
					cancel_building_mode()
				selected_building = null

		if event.button_index == MOUSE_BUTTON_RIGHT:
			if selected_building:
				cancel_building_mode()


# A* Algorithm PENDING IMPROVEMENTS TO GENERATE STRAIGHT ROADS MORE OFTEN

func a_star_search(start, goal):
	var open_set = PriorityQueue.new()
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

func movement_cost(from, to, last_dir, dir):
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
	



