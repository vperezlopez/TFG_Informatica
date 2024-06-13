extends Control

const VehicleModelCatalog = preload(Constants.VEHICLE_MODEL_CATALOG_PATH)
const VEHICLE_MENU = preload("res://Nodes/Menus/vehicle_menu.tscn")
const BUY_VEHICLE_MENU = preload("res://Nodes/Menus/buy_vehicle_menu.tscn")
@onready var slots_container = $SlotsContainer
@onready var models_container = $ModelsContainer

#@onready var slot_0 = $GridContainer/Slot0
#@onready var slot_1 = $GridContainer/Slot1
#@onready var slot_2 = $GridContainer/Slot2
#@onready var slot_3 = $GridContainer/Slot3
#@onready var slot_4 = $GridContainer/Slot4
#@onready var slot_5 = $GridContainer/Slot5

#@onready var slots = [slot_0, slot_1, slot_2, slot_3, slot_4, slot_5]

signal buy_vehicle(vehicle_model : VehicleModel, d : Depot)
signal find_vehicle(pos : Vector2i)
signal sell_vehicle(index : int, d : Depot)

var depot : Depot

var navigation = 1
var capacity = 6
var _index = 0

func _ready():
	# SLOTSCONTAINER
	for n in capacity:
		var vehicle_menu = VEHICLE_MENU.instantiate()
		slots_container.add_child(vehicle_menu)
		vehicle_menu.connect("new_vehicle_clicked", Callable(self, "_on_new_vehicle_clicked"))
		vehicle_menu.connect("find_clicked", Callable(self, "_on_find_clicked"))
		vehicle_menu.connect("remove_vehicle_clicked", Callable(self, "_on_remove_vehicle_clicked"))
		
	slots_container.get_child(_index).show_new_vehicle_button()
	
	# MODELSCONTAINER
	for vehicle_model in VehicleModelCatalog.get_vehicle_model_with_navigation(navigation):
		var model_info = BUY_VEHICLE_MENU.instantiate()
		models_container.add_child(model_info)
		model_info.initialize(vehicle_model)
		model_info.connect("buy_button_pressed", Callable(self, "_on_buy_button_pressed"))
	
	#for child in self.get_children():
		#print('Child: ' + str(child))
	##initialize.call_deferred(null)

func initialize(d : Depot):
	depot = d
	initialize_fleet(d.fleet)

func initialize_fleet(fleet : Array[Vehicle]):
	_index = 0
	
	for child in slots_container.get_children():
		child.remove_vehicle()
		child.show_new_vehicle_button(false)
	
	slots_container.get_child(_index).show_new_vehicle_button()
	
	for vehicle in fleet:
		add_vehicle(vehicle)

func add_vehicle(vehicle : Vehicle):
	slots_container.get_child(_index).add_vehicle(vehicle)
	_index += 1
	if _index < capacity:
		slots_container.get_child(_index).show_new_vehicle_button()
	
func remove_vehicle(i : int):
	slots_container.get_child(i).remove_vehicle()
	slots_container.get_child(_index).show_new_vehicle_button(false)
	_index -= 1
	for n in range(i, _index):
		#slots_container.get_child(n).add_vehicle(slots_container.get_child(n + 1).vehicle)
		#slots_container.get_child(n + 1).remove_vehicle()
		var v = slots_container.get_child(n + 1).remove_vehicle()
		slots_container.get_child(n).add_vehicle(v)
	
	slots_container.get_child(_index).show_new_vehicle_button()

func _on_new_vehicle_clicked():
	slots_container.visible = false
	models_container.visible = true

func _on_buy_button_pressed(vehicle_model : VehicleModel):
	emit_signal("buy_vehicle", vehicle_model, depot)
	#var vehicle = vehicle.instantiate()
	models_container.visible = false
	slots_container.visible = true
	initialize_fleet(depot.fleet)

func _on_find_clicked(sender):
	var pos = depot.fleet[slots_container.get_children().find(sender)].position
	emit_signal("find_vehicle", pos)

func _on_remove_vehicle_clicked(sender):
	var index = slots_container.get_children().find(sender)
	remove_vehicle(index)
	emit_signal("sell_vehicle", index, depot)
	#emit_signal("sell_vehicle", depot.fleet[index], depot)
	#print_debug('Deleting index: ' + str(index))


func _on_visibility_changed():
	if self.visible == false:
		depot = null
		_index = 0
		if slots_container:
			for child in slots_container.get_children():
				child.remove_vehicle()
