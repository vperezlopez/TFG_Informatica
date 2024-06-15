extends Control

const DESTINATION_MENU = preload("res://Nodes/Menus/destination_menu.tscn")
const LOAD_CARGO_MENU = preload("res://Nodes/Menus/load_cargo_menu.tscn")

@onready var button_wait = $HBoxContainer/LoadContainer/LoadTitleBox/ButtonWait

#@onready var load_cargo_container = $HBoxContainer/LoadContainer/ScrollContainer/LoadCargoContainer
@onready var load_cargo_container = $HBoxContainer/LoadContainer/LoadBox/ScrollContainer/LoadCargoContainer

@onready var label_title = $HBoxContainer/DestinationContainer/RouteTitleBox/HBoxContainer/LabelTitle
@onready var button_accept = $HBoxContainer/DestinationContainer/RouteTitleBox/HBoxContainer/ButtonAccept
@onready var button_cancel = $HBoxContainer/DestinationContainer/RouteTitleBox/HBoxContainer/ButtonCancel

#@onready var destinations_container = $HBoxContainer/DestinationContainer/ScrollContainer/DestinationsContainer
@onready var destinations_container = $HBoxContainer/DestinationContainer/DestinationsBox/ScrollContainer/DestinationsContainer
@onready var dest_default = $HBoxContainer/DestinationContainer/DestinationsBox/ScrollContainer/DestinationsContainer/DestDefault

#@onready var unload_cargo_container = $HBoxContainer/UnloadContainer/ScrollContainer/UnloadCargoContainer
@onready var unload_cargo_container = $HBoxContainer/UnloadContainer/UnloadBox/ScrollContainer/UnloadCargoContainer

var vehicle : Vehicle
var operations: Array[Operation]
var selected_destination : Operation

signal close_route_menu

func initialize(v : Vehicle):
	vehicle = v
	operations = vehicle.get_route().get_operations().duplicate(true)
	
	for child in destinations_container.get_children():
		if child is DestinationMenu:
			child.queue_free.call_deferred()
	
	#var children = destinations_container.get_children()
	#for i in range(children.size() - 1):
		#children[i].queue_free.call_deferred()
	
	reset_load_unload_containers()
	
	for operation in operations:
		add_destination_menu(operation.get_destination())
	
	if operations.size() > 0:
		selected_destination = operations[0]

func reset_load_unload_containers():
	for child in load_cargo_container.get_children():
		child.queue_free.call_deferred()
	for child in unload_cargo_container.get_children():
		child.queue_free.call_deferred()
	

func add_destination_menu(destination : Actor_Static = null):
	var destination_menu = DESTINATION_MENU.instantiate()
	destinations_container.add_child(destination_menu)
	destination_menu.initialize(destination)
	destination_menu.connect("up_clicked", Callable(self, "_on_up_clicked")) #self
	destination_menu.connect("down_clicked", Callable(self, "_on_down_clicked")) #self
	destination_menu.connect("find_clicked", Callable(self, "_on_find_clicked")) #position
	destination_menu.connect("remove_clicked", Callable(self, "_on_remove_clicked")) #self
	
	destinations_container.move_child(dest_default, destinations_container.get_child_count() - 1)
	

func remove_destination_menu(index : int):
	var destination_menu = destinations_container.get_child(index)
	remove_destination(index)
	destination_menu.queue_free.call_deferred()


func add_destination(actor_static : Actor_Static):
	print_debug('Adding destination')
	var operation = Operation.new()
	operation.initialize(actor_static)
	operations.append(operation)
	add_destination_menu(operation.get_destination())
	#vehicle.get_route().add_operation(operation)

func remove_destination(index : int):
	var r = operations.pop_at(index)
	print('Removed: ' + str(r.destination))

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
	vehicle.get_route().set_operations(operations)
	emit_signal("close_route_menu")


func _on_button_cancel_pressed():
	emit_signal("close_route_menu")


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

func _on_remove_clicked(sender):
	var index = destinations_container.get_children().find(sender)
	remove_destination_menu(index)
