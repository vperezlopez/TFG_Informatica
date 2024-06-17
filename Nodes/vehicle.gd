extends CharacterBody2D

class_name Vehicle

var collision_shape : CollisionShape2D
var sprite : Sprite2D
var navigation_agent : NavigationAgent2D

var vehicle_model : VehicleModel
var usage : float

var cargo_storage : CargoStorage
var route : Route
var current_destination_index : int

var time : float
var travel_time : float

var dispatching : bool

func _ready(): # INITIALIZE CHILDREN NODES
	# INITIALIZE COLLISION SHAPE
	#collision_shape = CollisionShape2D.new()
	#collision_shape.position = Vector2i(0, 0) # 0, 0?
	#collision_shape.shape = RectangleShape2D.new()
	#collision_shape.shape.extents = Vector2(16, 16)
	#add_child(collision_shape)
	
	# INITIALIZE SPRITE
	sprite = Sprite2D.new()
	sprite.position = Vector2i(0, 0) # 0, 0?
	add_child(sprite)
	#
	#navigation_agent = NavigationAgent2D.new()
	#add_child(navigation_agent)
	#navigation_agent.path_postprocessing = NavigationPathQueryParameters2D.PATH_POSTPROCESSING_EDGECENTERED
	#
	
	route = Route.new()
	current_destination_index = -1
	time = 0.0
	dispatching = false

func _physics_process(delta):
	if route and route.get_destinations().size() > 0:
		if current_destination_index == -1:
				current_destination_index = 0
				
		if dispatching:
			dispatch()
		else:
			time += delta
				#navigation_agent.target_position = route.get_destinations()[current_destination_index].position
			if time > travel_time:
				self.position = route.get_destinations()[current_destination_index].position
				dispatching = true
				time -= travel_time
				current_destination_index += 1
				if current_destination_index >= route.get_destinations().size():
					current_destination_index = -1
			#var next_pos = navigation_agent.get_next_path_position()
			##var direction = to_local(next_pos).normalized()
			#var direction = (next_pos - global_position).normalized()
			#velocity = direction * vehicle_model.speed
			##print("Navigation layers: " + str(navigation_agent.navigation_layers))
			#print("Target Position: ", navigation_agent.target_position)
			#print("Current Position: ", global_position)
			#print("Next Position: ", next_pos)
			#print("Direction: ", direction)
			#print("Velocity: ", velocity)
			#print("Is Navigation Finished: ", navigation_agent.is_navigation_finished())
			##self.position = next_pos
			#move_and_slide()
			##if destination.distance_to(global_position) > threshold:
			#if navigation_agent.is_navigation_finished():
				#current_destination_index += 1
				#if current_destination_index >= route.get_destinations().size():
					#current_destination_index = -1
				#navigation_agent.target_position = route.get_destinations()[current_destination_index].position

func initialize(vm : VehicleModel):
	self.vehicle_model = vm
	sprite.texture = load(vm.img_path)
	travel_time = 24.0 / vm.speed
	
	cargo_storage = CargoStorage.new()
	cargo_storage.init(100)
	#navigation_agent.navigation_layers = 1
	#navigation_agent.set_navigation_layer_value(vehicle_model.navigation, true)
	#navigation_agent.set_navigation_layer_value(3, true)
	
func get_route() -> Route:
	return route

func set_new_route(operations):
	var new_route = Route.new()
	new_route.initialize(operations)
	route = new_route
	cargo_storage.flush()
	#route.set_operations(operations)

func add_destination(operation : Operation):
	self.route.add_operation(operation)
	operation.get_destination().connect("accept_unload", Callable(self, "_on_accept_unload"))
	operation.get_destination().connect("accept_load", Callable(self, "_on_accept_unload"))


func dispatch():
	var current_operation = route.get_operations()[current_destination_index]
	var destination = current_operation.get_destination()
	var load_dict = current_operation.get_load_duplicate()
	var unload_dict = current_operation.get_unload_duplicate()
	var wait_load = current_operation.get_wait_load()
	
	for cargo in unload_dict:
		var quantity: int = min(unload_dict[cargo], cargo_storage.get_quantity(cargo))
		var unloaded : int = destination.unload_cargo(cargo, quantity)
		if unloaded == -1: break
		cargo_storage.remove_cargo(cargo, unloaded)
		unload_dict[cargo] = quantity - unloaded
	
	var do_while = true
	while (do_while):
		var load_remaining : int = 0
		for cargo in load_dict:
			var quantity: int = min(load_dict[cargo], cargo_storage.get_free_space())
			var loaded : int = destination.load_cargo(cargo, quantity)
			if loaded == -1: break
			cargo_storage.add_cargo(cargo, loaded)
			load_dict[cargo] = quantity - loaded
			load_remaining += load_dict[cargo]
		do_while = wait_load and load_remaining and cargo_storage.get_free_space() > 0
	
	#print('This vehicle is now transporting:')
	#var inventory = cargo_storage.get_inventory()
	#for tuple in inventory:
		#print('(' + tuple[0].name + ', ' + str(tuple[1]) + ')')
	
	dispatching = false



