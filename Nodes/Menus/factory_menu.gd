extends Control

@onready var input_storage_menu = $HBoxContainer/input_menu/ScrollContainer/input_storage

const CARGO_MENU = preload("res://Nodes/Menus/cargo_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func initialize(input_storage : CargoStorage, output_storage : CargoStorage):
	for cargo in input_storage.get_cargo():
		var quantity = input_storage.get_quantity(cargo)
		var cargo_menu = CARGO_MENU.instantiate()
		cargo_menu.initialize(cargo, quantity)
		input_storage_menu.add_child(cargo_menu)
		print_debug(str(cargo))
	pass
