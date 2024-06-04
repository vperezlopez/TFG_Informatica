extends Node2D

var map_width = 64 # *2
var map_height = 64 # /2

var n_cities = 5
var n_explotations = 0
var n_harbors = 0

var map_class = preload("res://Nodes/map.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if !FileAccess.file_exists(Constants.CATALOG_PATH):
		Catalog_Creator.create_catalog()
		await get_tree().process_frame

	var cargo_catalog = load(Constants.CATALOG_PATH) as CargoResource
	print(str(cargo_catalog.cargos.get(2, 'Not found').name))
	
	var map = map_class.instantiate()
	map.initialize(map_width, map_height, n_cities, n_explotations, n_harbors)
	add_child(map)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_control_gui_input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		print("Out click detected")
	pass # Replace with function body.




