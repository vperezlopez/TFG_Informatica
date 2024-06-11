extends Node

@onready var top_container = 	$VBoxContainer/top_container
@onready var game_container = 	$VBoxContainer/top_container/game_container
@onready var game_viewport = 	$VBoxContainer/top_container/game_container/game_viewport
@onready var map = 				$VBoxContainer/top_container/game_container/game_viewport/map
@onready var camera = $VBoxContainer/top_container/game_container/game_viewport/map/camera
@onready var bottom_container = $VBoxContainer/bottom_container

enum Screen {MAP, ROUTE, CITY, FACTORY, DEPOT}

# Called when the node enters the scene tree for the first time.
func _ready():
	if !FileAccess.file_exists(Constants.CARGO_CATALOG_PATH):
		Catalog_Creator.create_catalog()
		await get_tree().process_frame

	new_game(Vector2i(64, 64), 5, 0, 0)
	test()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func new_game(size : Vector2i, ncities : int, nexplotations : int, nharbors : int):
	map.initialize(size.x, size.y, ncities, nexplotations, nharbors)

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
	for e in cs.get_inventory():
		print("There are %d units of %s" % [e[1], e[0].name])
	$VBoxContainer/top_container/factory_menu.initialize(cs, null)



func _on_game_container_resized():
	if game_viewport and game_container:
		game_viewport.size = game_container.size













func _on_button_factory_pressed():
	map.build(map.BuildTypes.FACTORY)
	#map.set_build_mode(map.BuildMode.BUILDING, map.Buildings.FACTORY)

func _on_button_warehouse_pressed():
	map.build(map.BuildTypes.WAREHOUSE)
	#map.set_build_mode(map.BuildMode.BUILDING, map.Buildings.WAREHOUSE)

func _on_button_road_depot_pressed():
	map.build(map.BuildTypes.DEPOT_ROAD)
	#map.set_build_mode(map.BuildMode.BUILDING, map.Buildings.DEPOT_ROAD)

func _on_button_rail_depot_pressed():
	map.build(map.BuildTypes.DEPOT_RAILWAY)
	#map.set_build_mode(map.BuildMode.BUILDING, map.Buildings.DEPOT_RAIL)

func _on_button_road_pressed():
	map.build_path(map.PathTypes.ROAD)
	#map.set_build_mode(map.BuildMode.PATH.ROAD)

func _on_button_railway_pressed():
	map.build_path(map.PathTypes.RAILWAY)
	#map.set_build_mode(BuildMode.PATH.RAILWAY)

func _on_button_demolish_pressed():
	map.set_build_mode(map.BuildMode.DEMOLISH)

func _on_button_demolish_path_pressed():
	map.set_build_mode(map.BuildMode.DEMOLISH_PATH)
