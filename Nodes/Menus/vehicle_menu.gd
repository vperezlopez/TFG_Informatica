extends Control

@onready var title_label = $VBoxContainer/TitleContainer/TitleLabel
@onready var button_new = $VBoxContainer/TitleContainer/ButtonNew
@onready var vehicle_box = $VBoxContainer/VehicleContainer/MarginContainer/VehicleBox
@onready var vehicle_icon = $VBoxContainer/VehicleContainer/MarginContainer/VehicleBox/VehicleIcon

var vehicle : Vehicle

signal new_vehicle_clicked
signal find_clicked(sender)
signal remove_vehicle_clicked(sender)


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

func remove_vehicle() -> Vehicle:
	var res : Vehicle = self.vehicle
	self.vehicle = null
	title_label.text = ""
	vehicle_icon.texture = null
	vehicle_box.visible = false
	return res

func has_vehicle():
	return vehicle != null

func show_new_vehicle_button(b : bool = true):
	button_new.visible = b

func _on_button_new_pressed():
	emit_signal("new_vehicle_clicked")

func _on_button_find_pressed():
	emit_signal("find_clicked", self)
	#print_debug(vehicle.position)

func _on_button_edit_pressed():
	printerr('Route setting not implemented yet')

func _on_button_delete_pressed():
	emit_signal("remove_vehicle_clicked", self)


