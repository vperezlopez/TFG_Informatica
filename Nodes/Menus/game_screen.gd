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
	show_screen(ScreenMode.MAP)
	#test()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func connect_signals():
	const_menu.connect("const_button_clicked", Callable(map, "_on_construction_button_clicked"))
	map.connect("forwarded_actor_static_clicked", Callable(self, "_on_actor_static_clicked"))
	#load("res://Nodes/actor_static.tscn").connect("actor_static_clicked", Callable(map, "_on_static_actor_clicked"))

func new_game(size : Vector2i, ncities : int, nexplotations : int, nharbors : int):
	map.initialize(size.x, size.y, ncities, nexplotations, nharbors)
	pass

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


func _on_actor_static_clicked(actor_static_id):
	print_debug('Connection successful')
	print(str(instance_from_id(actor_static_id)))
	var actor_static_clicked : Actor_Static = instance_from_id(actor_static_id)
	print('Is factory?')
	if actor_static_clicked is Factory:
		print('Is factory')
		show_screen(ScreenMode.FACTORY)
	


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

#func _input(event):
	#if event is InputEventKey:
		#if event.pressed:
			#if event.keycode == KEY_ESCAPE:
				#show_screen(ScreenMode.MAP)
