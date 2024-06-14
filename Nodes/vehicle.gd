extends CharacterBody2D

class_name Vehicle

var collision_shape : CollisionShape2D
var sprite : Sprite2D

var vehicle_model : VehicleModel
var usage : float

var route : Route

func _ready(): # INITIALIZE CHILDREN NODES
	# INITIALIZE COLLISION SHAPE
	collision_shape = CollisionShape2D.new()
	collision_shape.position = Vector2i(0, -8)
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.extents = Vector2(16, 16)
	add_child(collision_shape)
	
	# INITIALIZE SPRITE
	sprite = Sprite2D.new()
	sprite.position = Vector2i(0, -8)
	add_child(sprite)
	
func initialize(vm : VehicleModel):
	self.vehicle_model = vm
	sprite.texture = load(vm.img_path)
	
	route = Route.new()
	
func get_route() -> Route:
	return route
