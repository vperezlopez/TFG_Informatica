extends Control

@onready var title_label = $VBoxContainer/TitleContainer/TitleLabel
@onready var button_new = $VBoxContainer/TitleContainer/ButtonNew
@onready var vehicle_box = $VBoxContainer/VehicleContainer/MarginContainer/VehicleBox
@onready var vehicle_icon = $VBoxContainer/VehicleContainer/MarginContainer/VehicleBox/VehicleIcon


var vehicle : Vehicle

#func initialize(vehicle_instance : Vehicle):
	#$VBoxContainer/Title_Container/Title_Label.text = vehicle_instance.vehicle_model.model_name
	#$VBoxContainer/Control/MarginContainer/HBoxContainer/TextureRect.texture = load(vehicle_instance.vehicle_model.img_path)

func add_vehicle(vehicle_instance : Vehicle):
	if vehicle:
		printerr('Overwriting vehicle')
	self.vehicle = vehicle_instance
	title_label.text = vehicle_instance.vehicle_model.model_name
	vehicle_icon.texture = load(vehicle_instance.vehicle_model.img_path)
	vehicle_box.visible = true
	show_new_vehicle_button(false)

func remove_vehicle():
	self.vehicle = null
	title_label.text = ""
	vehicle_icon.texture = null
	vehicle_box.visible = false

func has_vehicle():
	return vehicle != null

func show_new_vehicle_button(b : bool):
	button_new.visible = b

func _on_button_find_pressed():
	print_debug(vehicle.position)

func _on_button_edit_pressed():
	printerr('Route setting not implemented yet')

func _on_button_delete_pressed():
	remove_vehicle()
