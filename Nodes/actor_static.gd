extends StaticBody2D

class_name Actor_Static

var loc_name : String
var grid_pos : Vector2i

var collision_shape : CollisionShape2D
var sprite : Sprite2D
var label : Label
var demolishable : bool
#var static_actor_menu_scene = preload("res://Nodes/Menus/static_actor_menu.tscn")

var static_actor_menu #: Static_Actor_Menu

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
	
	# INITIALIZE LABEL
	label = Label.new()
	label.position = Vector2i(-32, -48)
	label.text = loc_name
	add_child(label)

func _on_input_event(_viewport, _event, _shape_idx):
	pass

func is_demolishable() -> bool:
	return demolishable
