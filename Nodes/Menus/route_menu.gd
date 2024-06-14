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
var selected_destination : Operation

func initialize(v : Vehicle):
	vehicle = v
	
	for destination in vehicle.get_route().get_destinations():
		var destination_menu = DESTINATION_MENU.instantiate()
		destinations_container.add_child(destination_menu)
		destination_menu.initialize(destination)
	
	if vehicle.get_route().get_operations_size() > 0:
		selected_destination = vehicle.get_route().get_operation(0)

func add_destination(actor_static : Actor_Static):
	print_debug('Adding destination')
	var operation = Operation.new()
	operation.initialize(actor_static)
	vehicle.get_route().add_operation(operation)
	
	initialize(vehicle)


