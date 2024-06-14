extends Control

const DESTINATION_MENU = preload("res://Nodes/Menus/destination_menu.tscn")
const LOAD_CARGO_MENU = preload("res://Nodes/Menus/load_cargo_menu.tscn")

@onready var button_wait = $HBoxContainer/LoadContainer/LoadTitleBox/ButtonWait
@onready var load_cargo_container = $HBoxContainer/LoadContainer/ScrollContainer/LoadCargoContainer

@onready var label_title = $HBoxContainer/DestinationContainer/RouteTitleBox/HBoxContainer/LabelTitle
@onready var button_accept = $HBoxContainer/DestinationContainer/RouteTitleBox/HBoxContainer/ButtonAccept
@onready var button_cancel = $HBoxContainer/DestinationContainer/RouteTitleBox/HBoxContainer/ButtonCancel
@onready var destinations_container = $HBoxContainer/DestinationContainer/ScrollContainer/DestinationsContainer

@onready var unload_cargo_container = $HBoxContainer/UnloadContainer/ScrollContainer/UnloadCargoContainer

var vehicle : Vehicle
var operations: Array[Operation]
var selected_destination : Operation

signal close_route_menu

func initialize(v : Vehicle):
	vehicle = v
	operations = vehicle.get_route().get_operations()
	
	for child in destinations_container.get_children():
		child.queue_free.call_deferred()
		
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

func add_destination(actor_static : Actor_Static):
	print_debug('Adding destination')
	var operation = Operation.new()
	operation.initialize(actor_static)
	operations.append(operation)
	add_destination_menu(operation.get_destination())
	#vehicle.get_route().add_operation(operation)
	
	#initialize(vehicle)




func _on_button_accept_pressed():
	var ops : Array[Operation] = []
	for operation in operations:
		ops.append(operation)
	vehicle.get_route().set_operations(ops)
	emit_signal("close_route_menu")


func _on_button_cancel_pressed():
	emit_signal("close_route_menu")
