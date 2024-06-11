extends Node

@onready var top_container = 	$VBoxContainer/top_container
@onready var game_container = 	$VBoxContainer/top_container/game_container
@onready var game_viewport = 	$VBoxContainer/top_container/game_container/game_viewport
@onready var map = 				$VBoxContainer/top_container/game_container/game_viewport/map
#@onready var camera = $VBoxContainer/top_container/game_container/game_viewport/map/camera
@onready var factory_menu = $VBoxContainer/top_container/factory_menu

@onready var bottom_container = $VBoxContainer/bottom_container
@onready var const_menu = $VBoxContainer/bottom_container/bottom_menu/const_menu
@onready var money_menu = $VBoxContainer/bottom_container/bottom_menu/money_menu
@onready var game_menu = $VBoxContainer/bottom_container/bottom_menu/game_menu

@onready var Menus = [game_container, factory_menu, const_menu, money_menu, game_menu]

enum ScreenMode {MAP, ROUTE, CITY, FACTORY, DEPOT}
var selected_screen : ScreenMode



# Called when the node enters the scene tree for the first time.
func _ready():
	if !FileAccess.file_exists(Constants.CARGO_CATALOG_PATH):
		Catalog_Creator.create_catalog()
		await get_tree().process_frame

	connect_signals()

	new_game(Vector2i(64, 64), 5, 0, 0)
	show_screen(ScreenMode.FACTORY)
	test()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func connect_signals():
	const_menu.connect("button_clicked", Callable(self, "_on_construction_button_clicked"))

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

func show_screen(new_screen : ScreenMode):
	hide_menus()
	match new_screen:
		ScreenMode.MAP:
			game_container.visible = true
			const_menu.visible = true
			money_menu.visible = true
			game_menu.visible = true
			pass
		ScreenMode.ROUTE:
			pass
		ScreenMode.CITY:
			pass
		ScreenMode.FACTORY:
			factory_menu.visible = true
			money_menu.visible = true
		ScreenMode.DEPOT:
			pass
	pass
	

func hide_menus():
	for menu in Menus:
		menu.visible = false

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if event.keycode == KEY_ESCAPE:
				show_screen(ScreenMode.MAP)







func _on_construction_button_clicked(const_button : Constants.ConstButtons):
	print_debug('Recieved construction input')
	match const_button:
		Constants.ConstButtons.FACTORY:
			map.build(map.BuildTypes.FACTORY)
		Constants.ConstButtons.WAREHOUSE:
			map.build(map.BuildTypes.WAREHOUSE)
		Constants.ConstButtons.DEPOT_ROAD:
			map.build(map.BuildTypes.DEPOT_ROAD)
		Constants.ConstButtons.DEPOT_RAILWAY:
			map.build(map.BuildTypes.DEPOT_RAILWAY)
		Constants.ConstButtons.ROAD:
			map.build_path(map.PathTypes.ROAD)
		Constants.ConstButtons.RAILWAY:
			map.build_path(map.PathTypes.RAILWAY)
		Constants.ConstButtons.DEMOLISH:
			map.set_build_mode(map.BuildMode.DEMOLISH)
		Constants.ConstButtons.DEMOLISH_PATH:
			map.set_build_mode(map.BuildMode.DEMOLISH_PATH)


#func _on_button_factory_pressed():
	#print_debug('Factory')
	#map.build(map.BuildTypes.FACTORY)
	##map.set_build_mode(map.BuildMode.BUILDING, map.Buildings.FACTORY)
#
#func _on_button_warehouse_pressed():
	#map.build(map.BuildTypes.WAREHOUSE)
	##map.set_build_mode(map.BuildMode.BUILDING, map.Buildings.WAREHOUSE)
#
#func _on_button_road_depot_pressed():
	#map.build(map.BuildTypes.DEPOT_ROAD)
	##map.set_build_mode(map.BuildMode.BUILDING, map.Buildings.DEPOT_ROAD)
#
#func _on_button_rail_depot_pressed():
	#map.build(map.BuildTypes.DEPOT_RAILWAY)
	##map.set_build_mode(map.BuildMode.BUILDING, map.Buildings.DEPOT_RAIL)
#
#func _on_button_road_pressed():
	#map.build_path(map.PathTypes.ROAD)
	##map.set_build_mode(map.BuildMode.PATH.ROAD)
#
#func _on_button_railway_pressed():
	#map.build_path(map.PathTypes.RAILWAY)
	##map.set_build_mode(BuildMode.PATH.RAILWAY)
#
#func _on_button_demolish_pressed():
	#map.set_build_mode(map.BuildMode.DEMOLISH)
#
#func _on_button_demolish_path_pressed():
	#map.set_build_mode(map.BuildMode.DEMOLISH_PATH)
