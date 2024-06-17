extends StaticBody2D

class_name Actor_Static

var loc_name : String
var grid_pos : Vector2i

var collision_shape : CollisionShape2D
var sprite : Sprite2D
var label : Label
var demolishable : bool

signal actor_static_clicked(instance_id)

func _ready(): 
	# INITIALIZE COLLISION SHAPE
	#collision_shape = CollisionShape2D.new()
	#add_child(collision_shape)
	#collision_shape.position = Vector2i(0, -8)
	#collision_shape.shape = RectangleShape2D.new()
	#collision_shape.shape.extents = Vector2(16, 16)
	
	# INITIALIZE SPRITE
	sprite = Sprite2D.new()
	add_child(sprite)
	sprite.position = Vector2i(0, 0) # 0, -8
	
	# INITIALIZE LABEL
	label = Label.new()
	add_child(label)
	label.position = Vector2i(-32, -48)
	#label.text = loc_name
	
	# INITIALIZE INPUT HANDLERS
	self.input_pickable = true
	#connect("input_event", Callable(self, "_on_input_event"))

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		print_debug('Click detected')
		emit_signal("actor_static_clicked", self.get_instance_id())


func is_demolishable() -> bool:
	return demolishable
	

func unload_cargo(cargo : Cargo, quantity : int) -> int:
	print_debug("This building does not accept cargo: " + str(self.get_class()))
	return -1

func load_cargo(cargo : Cargo, quantity : int) -> int:
	print_debug("This building does not offer cargo: " + str(self.get_class()))
	return -1

# TEST: TO BE DELETED
func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			print("Clicked on ", self.name)
			
#func _input(event):
	#if event is InputEventMouseButton:
		#if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			#print("Input on ", self.name)
