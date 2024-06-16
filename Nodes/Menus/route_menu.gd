extends Control

const cargo_catalog = preload(Constants.CARGO_CATALOG_PATH) as CargoCatalog

const DESTINATION_MENU = preload("res://Nodes/Menus/destination_menu.tscn")
const LOAD_CARGO_MENU = preload("res://Nodes/Menus/load_cargo_menu.tscn")

@onready var button_wait = $HBoxContainer/LoadContainer/LoadTitleBox/ButtonWait
@onready var load_cargo_container = $HBoxContainer/LoadContainer/LoadBox/ScrollContainer/LoadCargoContainer
@onready var load_default = $HBoxContainer/LoadContainer/LoadBox/ScrollContainer/LoadCargoContainer/LoadDefault
@onready var label_title = $HBoxContainer/DestinationContainer/RouteTitleBox/HBoxContainer/LabelTitle
@onready var button_accept = $HBoxContainer/DestinationContainer/RouteTitleBox/HBoxContainer/ButtonAccept
@onready var button_cancel = $HBoxContainer/DestinationContainer/RouteTitleBox/HBoxContainer/ButtonCancel
@onready var destinations_container = $HBoxContainer/DestinationContainer/DestinationsBox/ScrollContainer/DestinationsContainer
@onready var dest_default = $HBoxContainer/DestinationContainer/DestinationsBox/ScrollContainer/DestinationsContainer/DestDefault
@onready var unload_cargo_container = $HBoxContainer/UnloadContainer/UnloadBox/ScrollContainer/UnloadCargoContainer
@onready var unload_default = $HBoxContainer/UnloadContainer/UnloadBox/ScrollContainer/UnloadCargoContainer/UnloadDefault

var vehicle : Vehicle
var selected_destination : DestinationMenu = null
var options : Array[Cargo] = []

signal find_destination(pos)
signal close_route_menu

func initialize(v : Vehicle):
	vehicle = v
	var operations = vehicle.get_route().get_operations().duplicate(true)
	options = cargo_catalog.get_all_cargo()
	
	select_destination(null)
	reset_containers()
	
	for operation in operations:
		add_destination_menu(operation)
	
	#if operations.size() > 0:
		#select_destination(destinations_container.get_child(0))

func reset_containers():
	for child in destinations_container.get_children():
		if child is DestinationMenu:
			child.queue_free()

	reset_load_unload_containers()

	for child in unload_cargo_container.get_children():
		if child is LoadCargoMenu:
			child.queue_free()
	unload_default.visible = false

func add_destination(actor_static : Actor_Static):
	var operation = Operation.new()
	operation.initialize(actor_static)
	add_destination_menu(operation)

func add_destination_menu(operation : Operation):
	# CREATE THE SUB-MENU
	var destination_menu = DESTINATION_MENU.instantiate()
	destinations_container.add_child(destination_menu)
	destination_menu.initialize(operation)
	# MOVE THE BUTTON TO THE LAST PLACE
	destinations_container.move_child(dest_default, destinations_container.get_child_count() - 1)
	# SELECT THE NEW DESTINATION MENU
	select_destination(destination_menu)
	# CONNECT THE SIGNALS
	destination_menu.connect("up_clicked", Callable(self, "_on_up_clicked"))
	destination_menu.connect("down_clicked", Callable(self, "_on_down_clicked"))
	destination_menu.connect("find_clicked", Callable(self, "_on_find_clicked"))
	destination_menu.connect("edit_clicked", Callable(self, "_on_edit_clicked"))
	destination_menu.connect("remove_clicked", Callable(self, "_on_remove_clicked"))

func select_destination(destination_menu : DestinationMenu):
	# UNSELECT THE PREVIOUS ONE
	if selected_destination:
		selected_destination.highlight(false)
		save_load_unload_changes(selected_destination.get_operation())
	selected_destination = destination_menu
	
	# REFRESH THE LOAD AND UNLOAD MENUS
	reset_load_unload_containers()
	if destination_menu:
		destination_menu.highlight(true)
		set_load_unload_containers(destination_menu.get_operation())

func select_previous_destination(destination_menu : DestinationMenu):
	var index = destinations_container.get_children().find(destination_menu)
	if index == 0:
		# IF IT IS THE FIRST ONE, THERE IS NO PREVIOUS MENU.
		# CHECK IF THERE ARE OTHER MENUS THAT COULD BECOME ACTIVE.
		var n_menus : int = 0
		for child in destinations_container.get_children():
			if child is DestinationMenu:
				n_menus += 1
		if n_menus == 1:
			# IF THERE IS ONLY ONE LEFT, NONE SHOULD BE SELECTED
			select_destination(null)
		else:
			# THIS ELSE ONLY HAPPENS IF THERE ARE MORE THAN 1 MENU LEFT
			select_destination(destinations_container.get_child(index + 1))
	else:
		# BASE CASE
		select_destination(destinations_container.get_child(index - 1))

func remove_destination_menu(destination_menu : DestinationMenu):
	if destination_menu == selected_destination:
		select_previous_destination(destination_menu)
	destination_menu.queue_free.call_deferred()

func _on_button_accept_pressed():
	select_destination(null)
	var operations : Array[Operation] = []
	for child in destinations_container.get_children():
		if child is DestinationMenu:
			operations.append(child.operation)
	vehicle.get_route().set_operations(operations)
	
	emit_signal("close_route_menu")

func _on_button_cancel_pressed():
	select_destination(null)
	emit_signal("close_route_menu")

func _on_up_clicked(sender):
	# TODO
	pass

func _on_down_clicked(sender):
	# TODO
	pass

func _on_find_clicked(pos : Vector2):
	emit_signal("find_destination", pos)

func _on_edit_clicked(sender):
	select_destination(sender)

func _on_remove_clicked(sender):
	remove_destination_menu(sender)


#-----------------------------------------------------------#
# LOAD UNLOAD CONTAINERS AND MENUS
#-----------------------------------------------------------#

func set_load_unload_containers(operation : Operation):
	reset_load_unload_containers()
	load_default.visible = true
	unload_default.visible = true
	button_wait.disabled = false

	for cargo in operation.load_dict:
		add_load_cargo_menu(cargo, operation.load_dict[cargo])

	button_wait.button_pressed = operation.get_wait_load()

	for cargo in operation.unload_dict:
		add_unload_cargo_menu(cargo, operation.unload_dict[cargo])


func reset_load_unload_containers():
	# CLEAN LOAD_CARGO_CONTAINER AND HIDE/DISABLE ITS ASSOCIATED COMPONENTS
	for child in load_cargo_container.get_children():
		if child is LoadCargoMenu:
			child.queue_free()
	
	load_default.visible = false
	button_wait.button_pressed = false
	button_wait.disabled = true
	
	# CLEAN UNLOAD_CARGO_CONTAINER AND HIDE/DISABLE ITS ASSOCIATED COMPONENTS
	for child in unload_cargo_container.get_children():
		if child is LoadCargoMenu:
			child.queue_free()
	unload_default.visible = false

func add_load_cargo_menu(cargo : Cargo, quantity : int):
	var load_cargo_menu = LOAD_CARGO_MENU.instantiate()
	load_cargo_container.add_child(load_cargo_menu)
	load_cargo_menu.connect("remove_load", Callable(self, "_on_remove_load"))
	load_cargo_menu.initialize(options, cargo, quantity)
	load_cargo_container.move_child(load_default, load_cargo_container.get_child_count() - 1)

func add_unload_cargo_menu(cargo : Cargo, quantity : int):
	var unload_cargo_menu = LOAD_CARGO_MENU.instantiate()
	unload_cargo_container.add_child(unload_cargo_menu)
	unload_cargo_menu.connect("remove_load", Callable(self, "_on_remove_unload"))
	unload_cargo_menu.initialize(options, cargo, quantity)
	unload_cargo_container.move_child(unload_default, unload_cargo_container.get_child_count() - 1)

func save_load_unload_changes(operation : Operation):
	var load_dict = {}
	for child in load_cargo_container.get_children():
		if child is LoadCargoMenu:
			load_dict[child.get_selected_cargo()] = child.get_selected_quantity()
	operation.set_load_dict(load_dict)
	operation.set_wait_load(button_wait.button_pressed)

	var unload_dict = {}
	for child in unload_cargo_container.get_children():
		if child is LoadCargoMenu:
			unload_dict[child.get_selected_cargo()] = child.get_selected_quantity()
	operation.set_unload_dict(unload_dict)

func _on_remove_load(sender):
	var index : int = load_cargo_container.get_children().find(sender)
	load_cargo_container.get_child(index).queue_free()

func _on_remove_unload(sender):
	var index : int = unload_cargo_container.get_children().find(sender)
	unload_cargo_container.get_child(index).queue_free()

func _on_button_new_load_pressed():
	add_load_cargo_menu(null, 0)

func _on_button_new_unload_pressed():
	add_unload_cargo_menu(null, 0)

