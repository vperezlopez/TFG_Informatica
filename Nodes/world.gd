extends Node2D

var map_width = 64 # *2
var map_height = 64 # /2

var n_cities = 5
var n_explotations = 0
var n_harbors = 0

var map_class = preload("res://Nodes/map.tscn")
var interface_class = preload("res://Nodes/Menus/game_interface.tscn")

@onready var map = $SubViewportContainer/SubViewport/map

# Called when the node enters the scene tree for the first time.
func _ready():
	if !FileAccess.file_exists(Constants.CARGO_CATALOG_PATH):
		Catalog_Creator.create_catalog()
		await get_tree().process_frame

	new_game(Vector2i(map_width, map_height), n_cities, n_explotations, n_harbors)

	var game_interface = interface_class.instantiate()
	add_child(game_interface)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func new_game(size : Vector2i, ncities : int, nexplotations : int, nharbors : int):
	#var map = map_class.instantiate()@onready var map = $SubViewportContainer/SubViewport/map

	#var map = $GameContainer/map
	map.initialize(size.x, size.y, ncities, nexplotations, nharbors)
	#add_child(map)

func test():
	var cargo_catalog = load(Constants.CARGO_CATALOG_PATH) as CargoCatalog
	var cs = CargoStorage.new()
	var c = cargo_catalog.get_cargo(2)
	#print(str(cargo_catalog.cargos.get(2, 'Not found').name))
	print(str(c.name))
	
	var q = 8
	var res
	
	cs.init(q, [cargo_catalog.get_cargo(3), cargo_catalog.get_cargo(2), cargo_catalog.get_cargo(1)], [cargo_catalog.get_cargo(3)])
	res = cs.add_cargo(cargo_catalog.get_cargo(2))
	print("Added %d units of %s" % [res, c.name])
	
	res = cs.get_quantity(c)
	print("There are %d units of %s" % [res, c.name])
	
	c = cargo_catalog.get_cargo(1)
	res = cs.remove_cargo(c, 4)
	print("Removed %d units of %s" % [res, c.name])
	
	c = cargo_catalog.get_cargo(2)
	res = cs.remove_cargo(c, 1)
	print("Removed %d units of %s" % [res, c.name])
	
	c = cargo_catalog.get_cargo(2)
	res = cs.remove_cargo(c, 18)
	print("Removed %d units of %s" % [res, c.name])
	
	res = cs.get_quantity(c)
	print("There are %d units of %s" % [res, c.name])
	
	res = cs.add_cargo(cargo_catalog.get_cargo(1), 3)
	res = cs.add_cargo(cargo_catalog.get_cargo(3), 3)
	res = cs.add_cargo(cargo_catalog.get_cargo(3), 9)
	res = cs.add_cargo(cargo_catalog.get_cargo(4), 3)
	res = cs.add_cargo(cargo_catalog.get_cargo(4), 9)
	res = cs.add_cargo(cargo_catalog.get_cargo(2), 9)
	res = cs.remove_cargo(cargo_catalog.get_cargo(6))
	for e in cs.get_cargo():
			print("There are %d units of %s" % [e[1], e[0].name])


