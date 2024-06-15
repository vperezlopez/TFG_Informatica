extends Control

const cargo_catalog = preload(Constants.CARGO_CATALOG_PATH) as CargoCatalog

const DESTINATION_MENU = preload("res://Nodes/Menus/destination_menu.tscn")
const LOAD_CARGO_MENU = preload("res://Nodes/Menus/load_cargo_menu.tscn")

@onready var button_wait = $HBoxContainer/LoadContainer/LoadTitleBox/ButtonWait

#@onready var load_cargo_container = $HBoxContainer/LoadContainer/ScrollContainer/LoadCargoContainer
@onready var load_cargo_container = $HBoxContainer/LoadContainer/LoadBox/ScrollContainer/LoadCargoContainer
@onready var load_default = $HBoxContainer/LoadContainer/LoadBox/ScrollContainer/LoadCargoContainer/LoadDefault

@onready var label_title = $HBoxContainer/DestinationContainer/RouteTitleBox/HBoxContainer/LabelTitle
@onready var button_accept = $HBoxContainer/DestinationContainer/RouteTitleBox/HBoxContainer/ButtonAccept
@onready var button_cancel = $HBoxContainer/DestinationContainer/RouteTitleBox/HBoxContainer/ButtonCancel

#@onready var destinations_container = $HBoxContainer/DestinationContainer/ScrollContainer/DestinationsContainer
@onready var destinations_container = $HBoxContainer/DestinationContainer/DestinationsBox/ScrollContainer/DestinationsContainer
@onready var dest_default = $HBoxContainer/DestinationContainer/DestinationsBox/ScrollContainer/DestinationsContainer/DestDefault

#@onready var unload_cargo_container = $HBoxContainer/UnloadContainer/ScrollContainer/UnloadCargoContainer
@onready var unload_cargo_container = $HBoxContainer/UnloadContainer/UnloadBox/ScrollContainer/UnloadCargoContainer
@onready var unload_default = $HBoxContainer/UnloadContainer/UnloadBox/ScrollContainer/UnloadCargoContainer/UnloadDefault

var vehicle : Vehicle
var operations: Array[Operation]
var selected_destination : DestinationMenu
var options : Array[Cargo]
#var selected_destination_index : int = -1
#const LAST : int = -99

signal close_route_menu

func initialize(v : Vehicle):
	vehicle = v
	operations = vehicle.get_route().get_operations().duplicate(true)
	select_destination(null)
	#selected_destination = null
	
	options = []
	for index in cargo_catalog.get_cargo_all():
		options.append(cargo_catalog.get_cargo(index))
	
	#var children = destinations_container.get_children()
	#for i in range(children.size() - 1):
		#children[i].queue_free.call_deferred()
	
	reset_containers()
	
	print(str(destinations_container.get_child_count()))
	
	for operation in operations:
		add_destination_menu(operation.get_destination())
	
	if operations.size() > 0:
		select_destination(destinations_container.get_child(0))
		#selected_destination = destinations_container.get_child(0)
	#select_destination(LAST)
	
	#if operations.size() > 0:
		#select_destination(0)
		#selected_destination_index = operations[0]

func reset_containers():
	# DESTINATIONS
	for child in destinations_container.get_children():
		if child is DestinationMenu:
			destinations_container.remove_child(child)
			child.queue_free()#.call_deferred()
	
	reset_load_unload_containers()

func reset_load_unload_containers():
	# LOAD
	for child in load_cargo_container.get_children():
		if child is LoadCargoMenu:
			child.queue_free.call_deferred()
	load_default.visible = false
	button_wait.button_pressed = false
	button_wait.disabled = true
	
	# UNLOAD
	for child in unload_cargo_container.get_children():
		if child is LoadCargoMenu:
			child.queue_free.call_deferred()
	unload_default.visible = false

# DESTINATIONS

# ENTRY POINT FROM THE OUTSIDE
func add_destination(actor_static : Actor_Static):
	var operation = Operation.new()
	operation.initialize(actor_static)
	operations.append(operation)
	add_destination_menu(operation.get_destination())

func add_destination_menu(destination : Actor_Static = null):
	var destination_menu = DESTINATION_MENU.instantiate()
	destinations_container.add_child(destination_menu)
	destination_menu.initialize(destination)
	# MOVE THE TEXTBOX TO BOTTOM
	destinations_container.move_child(dest_default, destinations_container.get_child_count() - 1)
	# HIGHLIGHT THE NEW MENU
	select_destination(destination_menu)
	# CONNECT SIGNALS
	#destination_menu.connect("destination_selected", Callable(self, "_on_destination_selected"))
	destination_menu.connect("up_clicked", Callable(self, "_on_up_clicked"))
	destination_menu.connect("down_clicked", Callable(self, "_on_down_clicked"))
	destination_menu.connect("find_clicked", Callable(self, "_on_find_clicked"))
	destination_menu.connect("edit_clicked", Callable(self, "_on_edit_clicked"))
	destination_menu.connect("remove_clicked", Callable(self, "_on_remove_clicked"))
	

func remove_destination_menu(index : int):
	var destination_menu = destinations_container.get_child(index)
	remove_destination(index)
	if selected_destination == destination_menu:
		select_previous_destination(destination_menu)
	destination_menu.queue_free.call_deferred()

func remove_destination(index : int):
	var r = operations.pop_at(index)
	print('Removed: ' + str(r.destination))


func select_destination(destination_menu : DestinationMenu):
	if selected_destination:
		selected_destination.highlight(false)
		if operations.size() > -1:
			var index = destinations_container.get_children().find(selected_destination)
			save_load_unload_changes(operations[index])
		
	reset_load_unload_containers()
	selected_destination = destination_menu
	if destination_menu:
		destination_menu.highlight(true)
		var index = destinations_container.get_children().find(destination_menu)
		set_load_unload_containers(operations[index])
		
	
func select_previous_destination(destination_menu : DestinationMenu):
	var index = destinations_container.get_children().find(destination_menu)
	if index < 1:
		select_destination(null)
	else:
		select_destination(destinations_container.get_child(index - 1))

func save_load_unload_changes(operation : Operation):
	# SAVE LOAD
	var load_dict = {}
	for child in load_cargo_container.get_children():
		if child is LoadCargoMenu:
			load_dict[child.get_selected_cargo()] = child.get_selected_quantity()
	operation.set_load_dict(load_dict)
	operation.set_wait_load(button_wait.button_pressed)
	
	# SAVE UNLOAD
	var unload_dict = {}
	for child in unload_cargo_container.get_children():
		if child is LoadCargoMenu:
			unload_dict[child.get_selected_cargo()] = child.get_selected_quantity()
	operation.set_unload_dict(unload_dict)

func set_load_unload_containers(operation : Operation):
	#var options : Array[Cargo] = []
	#for index in cargo_catalog.get_cargo_all():
		#options.append(cargo_catalog.get_cargo(index))
	
	
	reset_load_unload_containers()
	
	load_default.visible = true
	unload_default.visible = true
	button_wait.disabled = false
	
	for cargo in operation.load_dict.keys():
		add_load_cargo_menu(options, cargo, operation.load_dict[cargo])
		#var load_cargo_menu = LOAD_CARGO_MENU.instantiate()
		#load_cargo_container.add_child(load_cargo_menu)
		#load_cargo_menu.initialize(options, cargo, operation.load_dict[cargo])
	
	button_wait.button_pressed = operation.get_wait_load()
	
	for cargo in operation.unload_dict.keys():
		add_unload_cargo_menu(options, cargo, operation.unload_dict[cargo])
		#var load_cargo_menu = LOAD_CARGO_MENU.instantiate()
		#unload_cargo_container.add_child(load_cargo_menu)
		#load_cargo_menu.initialize(options, cargo, operation.unload_dict[cargo])
	
	#load_cargo_container.initialize(operation.load_dict)
	#unload_cargo_container.initialize(operation.unload_dict)

#func select_destination(index : int):
	#if index == LAST:
		#index = destinations_container.get_child_count() - 2
	#
	#if selected_destination_index >= 0:
		#print_debug('Previous highlight: ' + str(destinations_container.get_child(selected_destination_index)))
		#destinations_container.get_child(selected_destination_index).highlight(false)
	#reset_load_unload_containers()
	#selected_destination_index = index
	#if index >= 0:
		#print_debug('New highlight: ' + str(destinations_container.get_child(index)))
		#for child in destinations_container.get_children():
			#print(str(child))
		#destinations_container.get_child(index).highlight(true)
	
	#var destination_menu = destinations_container.get_child(index)
	#if selected_destination_index:
		#selected_destination_index.highlight(false)
	#selected_destination_index = dest
	#selected_destination_index.highlight(true)
	#destinations_container.get_child(index).highlight(true)


# LOAD MENU
func add_load_cargo_menu(options : Array[Cargo], cargo : Cargo, quantity : int):
	var load_cargo_menu = LOAD_CARGO_MENU.instantiate()
	load_cargo_container.add_child(load_cargo_menu)
	load_cargo_menu.connect("remove_load", Callable(self, "_on_remove_load"))
	load_cargo_menu.initialize(options, cargo, quantity)
	
	load_cargo_container.move_child(load_default, load_cargo_container.get_child_count() - 1)


# UNLOAD MENU
func add_unload_cargo_menu(options : Array[Cargo], cargo : Cargo, quantity : int):
	var unload_cargo_menu = LOAD_CARGO_MENU.instantiate()
	unload_cargo_container.add_child(unload_cargo_menu)
	#load_cargo_menu.initialize()
	unload_cargo_menu.connect("remove_load", Callable(self, "_on_remove_unload"))
	unload_cargo_menu.initialize(options, cargo, quantity)
	
	unload_cargo_container.move_child(unload_default, unload_cargo_container.get_child_count() - 1)

# TO DELETE
func show_debug():
	#print_debug('Number of operations: ' + str(operations.size()))
	#for i in range(operations.size()):
		#print(operations[i])
		#
	#print_debug('Number of children: ' + str(destinations_container.get_child_count()))
	#for j in range(destinations_container.get_child_count()):
		#print(destinations_container.get_child(j))
	
	#print_debug('Comparing destinations: ')
	#for k in range(operations.size()):
		#
		#var dest_op = operations[k].destination
		#var dest_menu = (destinations_container.get_child(k) as DestinationMenu).destination
		#print('Comparing: ' + str(k))
		#print(str(dest_op))
		#print(str(dest_menu))
		#print(str(dest_op == dest_menu))
		#print("\n")
		
		#print(operations[k].destination)
		#print((destinations_container.get_child(k) as DestinationMenu).destination)
	pass

func _on_button_accept_pressed():
	save_load_unload_changes(operations[destinations_container.get_children().find(selected_destination)])
	vehicle.get_route().set_operations(operations)
	emit_signal("close_route_menu")


func _on_button_cancel_pressed():
	emit_signal("close_route_menu")

#func _on_destination_selected(sender):
	#var index = destinations_container.get_children().find(sender)
	#select_destination(index)

func _on_up_clicked(sender):
	print('Up')
	print_debug(str(sender))
	pass

func _on_down_clicked(sender):
	print('Down')
	print_debug(str(sender))
	pass

func _on_find_clicked(pos : Vector2):
	print('Find')
	print_debug(str(pos))
	pass

func _on_edit_clicked(sender):
	select_destination(sender)
	pass

func _on_remove_clicked(sender):
	var index = destinations_container.get_children().find(sender)
	remove_destination_menu(index)

func _on_remove_load(sender):
	var index : int = load_cargo_container.get_children().find(sender)
	load_cargo_container.get_child(index).queue_free.call_deferred()
	
	#remove_destination_menu(index)


func _on_remove_unload(sender):
	var index : int = unload_cargo_container.get_children().find(sender)
	unload_cargo_container.get_child(index).queue_free.call_deferred()


func _on_button_new_load_pressed():
	add_load_cargo_menu(options, null, 0)


func _on_button_new_unload_pressed():
	add_unload_cargo_menu(options, null, 0)
	pass # Replace with function body.
