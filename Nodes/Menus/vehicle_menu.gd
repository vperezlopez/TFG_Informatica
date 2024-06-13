extends Control

func initialize(vehicle : Vehicle):
	$VBoxContainer/Title_Container/Title_Label.text = vehicle.vehicle_model.model_name
	$VBoxContainer/Control/MarginContainer/HBoxContainer/TextureRect.texture = load(vehicle.vehicle_model.img_path)
