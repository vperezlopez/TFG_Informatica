extends CharacterBody2D

class_name Vehicle

var collision_shape : CollisionShape2D
var sprite : Sprite2D
var navigation_agent : NavigationAgent2D

var vehicle_model : VehicleModel
var usage : float

var route : Route
var current_destination_index : int

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
	
	navigation_agent = NavigationAgent2D.new()
	add_child(navigation_agent)
	navigation_agent.path_postprocessing = NavigationPathQueryParameters2D.PATH_POSTPROCESSING_EDGECENTERED
	
	current_destination_index = -1

func _physics_process(delta):
	if route and route.get_destinations().size() > 0:
		if current_destination_index == -1:
			current_destination_index = 0
			navigation_agent.target_position = route.get_destinations()[current_destination_index].position

		var next_pos = navigation_agent.get_next_path_position()
		#print('Target position: ' + str(navigation_agent.target_position))
		#print('Next_pos: ' + str(next_pos))
		#var direction = to_local(next_pos).normalized()
		var direction = (next_pos - global_position).normalized()
		#var direction = Vector2(1.0, 0)
		#print('Direction: ' + str(direction))
		velocity = direction * vehicle_model.speed
		
		print("Next Position: ", next_pos)
		print("Current Position: ", global_position)
		print("Direction: ", direction)
		print("Velocity: ", velocity)
		print("Target Position: ", navigation_agent.target_position)
		print("Is Navigation Finished: ", navigation_agent.is_navigation_finished())
		
		#if destination.distance_to(global_position) > threshold:
		if navigation_agent.is_navigation_finished():
			current_destination_index += 1
			if current_destination_index >= route.get_destinations().size():
				current_destination_index = 0
			navigation_agent.target_position = route.get_destinations()[current_destination_index].position
		move_and_slide()

func initialize(vm : VehicleModel):
	self.vehicle_model = vm
	sprite.texture = load(vm.img_path)
	navigation_agent.set_navigation_layer_value(vehicle_model.navigation, true)
	
	route = Route.new()
	
func get_route() -> Route:
	return route


