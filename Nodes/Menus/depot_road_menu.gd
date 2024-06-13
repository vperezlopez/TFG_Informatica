extends Control

const VEHICLE_MENU = preload("res://Nodes/Menus/depot_road_menu.tscn")

@onready var slot_0 = $GridContainer/Slot0
@onready var slot_1 = $GridContainer/Slot1
@onready var slot_2 = $GridContainer/Slot2
@onready var slot_3 = $GridContainer/Slot3
@onready var slot_4 = $GridContainer/Slot4
@onready var slot_5 = $GridContainer/Slot5

@onready var slots = [slot_0, slot_1, slot_2, slot_3, slot_4, slot_5]

func _ready():
	pass
	#for child in self.get_children():
		#print('Child: ' + str(child))
	##initialize.call_deferred(null)

func initialize(fleet : Array[Vehicle]):
	print('Depot initialization')
	for vehicle in fleet:
		var vehicle_menu = VEHICLE_MENU.instantiate()
		slot_0.add_child(vehicle_menu)
		print_debug(str(vehicle_menu.get_class()))
		print_debug(str(vehicle_menu.has_method("initialize")))
		vehicle_menu.initialize(vehicle)
	for slot in slots:
		print('Child: ' + str(slot.get_children()))
