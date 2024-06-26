extends Node

const vehicle = preload("res://Nodes/vehicle.tscn")

@onready var top_container = 	$VBoxContainer/top_container
@onready var game_container = 	$VBoxContainer/top_container/game_container
@onready var game_viewport = 	$VBoxContainer/top_container/game_container/game_viewport
@onready var map = 				$VBoxContainer/top_container/game_container/game_viewport/map
@onready var camera = $VBoxContainer/top_container/game_container/game_viewport/camera
@onready var factory_menu = $VBoxContainer/top_container/factory_menu
@onready var depot_road_menu = $VBoxContainer/top_container/depot_road_menu
@onready var exit_menu = $VBoxContainer/top_container/exit_menu

@onready var bottom_container = $VBoxContainer/bottom_container
@onready var const_menu = $VBoxContainer/bottom_container/bottom_menu/const_menu
@onready var cargo_mini_menu = $VBoxContainer/bottom_container/bottom_menu/cargo_mini_menu
@onready var money_menu = $VBoxContainer/bottom_container/bottom_menu/money_menu
@onready var game_menu = $VBoxContainer/bottom_container/bottom_menu/game_menu
@onready var route_menu = $VBoxContainer/bottom_container/bottom_menu/route_menu


@onready var Menus = [game_container, factory_menu, depot_road_menu, exit_menu, const_menu, cargo_mini_menu, money_menu, game_menu, route_menu]

enum ScreenMode {MAP, ROUTE, CITY, FACTORY, DEPOT, EXPLOTATION, EXIT}
var selected_screen : ScreenMode

const starting_money : float = 3000000.00
var money : float

# Called when the node enters the scene tree for the first time.
func _ready():
	#if !FileAccess.file_exists(Constants.CARGO_CATALOG_PATH):
		#Catalog_Creator.create_catalogs()
		#await get_tree().process_frame
	
	Catalog_Creator.create_catalogs()
	
	connect_signals()

	#if get_parent() is Window:
		#print_debug('Manual initialization')
		#new_game(Vector2i(64, 64), 12, 4, 2)
	
	money = 0
	update_money(+starting_money)
	
	#test_cargo()
	#test_vehicle()

	show_screen(ScreenMode.MAP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func connect_signals():
	const_menu.connect("const_button_clicked", Callable(map, "_on_construction_button_clicked"))
	map.connect("forwarded_actor_static_clicked", Callable(self, "_on_actor_static_clicked"))
	map.connect("map_transaction", Callable(self, "_on_map_transaction"))
	factory_menu.connect("close_factory_menu", Callable(self, "_on_close_factory_menu"))
	depot_road_menu.connect("buy_vehicle", Callable(self, "_on_buy_vehicle"))
	depot_road_menu.connect("find_vehicle", Callable(self, "_on_find_vehicle"))
	depot_road_menu.connect("set_route", Callable(self, "_on_set_route_vehicle"))
	depot_road_menu.connect("sell_vehicle", Callable(self, "_on_sell_vehicle"))
	route_menu.connect("find_destination", Callable(self, "_on_find_destination"))
	route_menu.connect("close_route_menu", Callable(self, "_on_close_route_menu"))
	game_menu.connect("exit_game", Callable(self, "_on_exit_game"))
	exit_menu.connect("back_to_game", Callable(self, "_on_back_to_game"))
	exit_menu.connect("back_to_main", Callable(self, "_on_back_to_main"))
	exit_menu.connect("back_to_desktop", Callable(self, "_on_back_to_desktop"))
	
	#load("res://Nodes/actor_static.tscn").connect("actor_static_clicked", Callable(map, "_on_static_actor_clicked"))

func new_game(size : Vector2i, ncities : int, nexplotations : int, nharbors : int):
	map.initialize(size.x, size.y, ncities, nexplotations, nharbors)
	
	var center_x = (map.tile_set.tile_size.x * size.x) / 2
	var center_y = (map.tile_set.tile_size.y * size.y) / 2
	# We have to half the center position because the camera itself is not centered, but anchored to the top_left corner
	camera.set_starting_position(Vector2i(center_x / 2, center_y / 2))
	camera.set_map_limits(Vector2i(center_x, center_y))

func test_cargo():
	var cargo_catalog = load(Constants.CARGO_CATALOG_PATH) as CargoCatalog
	var cs = CargoStorage.new()
	var c = cargo_catalog.get_cargo(2)
	#print(str(cargo_catalog.cargos.get(2, 'Not found').name))
	print(str(c.name))
	
	var q = 8
	var res
	
	cs.init(q, [cargo_catalog.get_cargo(3), cargo_catalog.get_cargo(2), cargo_catalog.get_cargo(1)], [cargo_catalog.get_cargo(3)])
	res = cs.add_cargo(cargo_catalog.get_cargo(2))
	#print("Added %d units of %s" % [res, c.name])
	
	res = cs.get_quantity(c)
	#print("There are %d units of %s" % [res, c.name])
	
	c = cargo_catalog.get_cargo(1)
	res = cs.remove_cargo(c, 4)
	#print("Removed %d units of %s" % [res, c.name])
	
	c = cargo_catalog.get_cargo(2)
	res = cs.remove_cargo(c, 1)
	#print("Removed %d units of %s" % [res, c.name])
	
	c = cargo_catalog.get_cargo(2)
	res = cs.remove_cargo(c, 18)
	#print("Removed %d units of %s" % [res, c.name])
	
	res = cs.get_quantity(c)
	#print("There are %d units of %s" % [res, c.name])
	
	res = cs.add_cargo(cargo_catalog.get_cargo(1), 3)
	res = cs.add_cargo(cargo_catalog.get_cargo(3), 3)
	res = cs.add_cargo(cargo_catalog.get_cargo(3), 9)
	res = cs.add_cargo(cargo_catalog.get_cargo(4), 3)
	res = cs.add_cargo(cargo_catalog.get_cargo(4), 9)
	res = cs.add_cargo(cargo_catalog.get_cargo(2), 9)
	res = cs.remove_cargo(cargo_catalog.get_cargo(6))
	for e in cs.get_inventory():
		print("There are %d units of %s" % [e[1], e[0].name])
	#$VBoxContainer/top_container/factory_menu.initialize_storage(cs, null)

func test_vehicle():
	var vehicle_model_catalog = load(Constants.VEHICLE_MODEL_CATALOG_PATH) as VehicleModelCatalog
	
	var fleet : Array[Vehicle]
	var v = vehicle.instantiate()
	add_child(v)
	v.initialize(vehicle_model_catalog.get_vehicle_model(1))
	fleet.append(v)
	
	var v2 = vehicle.instantiate()
	add_child(v2)
	#var vehicle_model_catalog = load(Constants.VEHICLE_MODEL_CATALOG_PATH) as VehicleModelCatalog
	v2.initialize(vehicle_model_catalog.get_vehicle_model(2))
	fleet.append(v2)
	
	var v3 = vehicle.instantiate()
	add_child(v3)
	#var vehicle_model_catalog = load(Constants.VEHICLE_MODEL_CATALOG_PATH) as VehicleModelCatalog
	v3.initialize(vehicle_model_catalog.get_vehicle_model(1))
	fleet.append(v3)
	
	var v4 = vehicle.instantiate()
	add_child(v4)
	#var vehicle_model_catalog = load(Constants.VEHICLE_MODEL_CATALOG_PATH) as VehicleModelCatalog
	v4.initialize(vehicle_model_catalog.get_vehicle_model(2))
	fleet.append(v4)
	
	var v5 = vehicle.instantiate()
	add_child(v5)
	#var vehicle_model_catalog = load(Constants.VEHICLE_MODEL_CATALOG_PATH) as VehicleModelCatalog
	v5.initialize(vehicle_model_catalog.get_vehicle_model(1))
	fleet.append(v5)
	
	$VBoxContainer/top_container/depot_road_menu.initialize_fleet(fleet)
	
	pass

func update_money(amount : float):
	money += amount
	money_menu.update_money(money)

func _on_game_container_resized():
	if game_viewport and game_container:
		game_viewport.size = game_container.size

func _on_actor_static_clicked(actor_static_id):
	#print_debug('Connection successful')
	var actor_static_clicked : Actor_Static = instance_from_id(actor_static_id)
	if selected_screen == ScreenMode.MAP:
		#print_debug('Construction')
		if actor_static_clicked is Factory:
			factory_menu.initialize(actor_static_clicked)
			show_screen(ScreenMode.FACTORY)
		if actor_static_clicked is Depot:
			depot_road_menu.initialize(actor_static_clicked)
			show_screen(ScreenMode.DEPOT)
		if actor_static_clicked is Explotation:
			cargo_mini_menu.initialize(actor_static_clicked)
			show_screen(ScreenMode.EXPLOTATION)
		
	elif selected_screen == ScreenMode.ROUTE:
		#print_debug('Route setting')
		route_menu.add_destination(actor_static_clicked)

func _on_map_transaction(charge : float):
	update_money(charge)

func _on_close_factory_menu():
	show_screen(ScreenMode.MAP)

func _on_buy_vehicle(vehicle_model : VehicleModel, depot : Depot):
	# VALIDATE MONEY: TODO
	map.create_vehicle(vehicle_model, depot)

func _on_find_vehicle(pos : Vector2i):
	show_screen(ScreenMode.MAP)
	camera.set_starting_position(pos)

func _on_set_route_vehicle(vehicle : Vehicle):
	route_menu.initialize(vehicle)
	show_screen(ScreenMode.ROUTE)

func _on_sell_vehicle(index, depot):
	# VALIDATE MONEY: TODO
	map.delete_vehicle(index, depot)

func _on_find_destination(pos : Vector2i):
	camera.set_starting_position(pos)

func _on_close_route_menu():
	show_screen(ScreenMode.MAP)

func _on_exit_game():
	show_screen(ScreenMode.EXIT)

func _on_back_to_game():
	show_screen(ScreenMode.MAP)

func _on_back_to_main():
	var main_menu = load("res://Nodes/Menus/main_menu.tscn").instantiate()
	get_tree().root.add_child(main_menu)
	queue_free()

func _on_back_to_desktop():
	get_tree().quit()

func show_screen(new_screen : ScreenMode):
	hide_menus()
	match new_screen:
		ScreenMode.MAP:
			game_container.visible = true
			const_menu.visible = true
			money_menu.visible = true
			game_menu.visible = true
		ScreenMode.ROUTE:
			game_container.visible = true
			route_menu.visible = true
		ScreenMode.CITY:
			pass
		ScreenMode.FACTORY:
			factory_menu.visible = true
			money_menu.visible = true
		ScreenMode.DEPOT:
			depot_road_menu.visible = true
			money_menu.visible = true
		ScreenMode.EXPLOTATION:
			game_container.visible = true
			cargo_mini_menu.visible = true
			money_menu.visible = true
			game_menu.visible = true
		ScreenMode.EXIT:
			exit_menu.visible = true
	selected_screen = new_screen
	

func hide_menus():
	for menu in Menus:
		menu.visible = false

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_ESCAPE:
				show_screen(ScreenMode.MAP)
