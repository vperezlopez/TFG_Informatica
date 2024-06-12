extends Control

func initialize(vehicle : Vehicle):
	$VBoxContainer/Title_Container/Title_Label.text = vehicle.name
	$VBoxContainer/Control/MarginContainer/HBoxContainer/TextureRect.texture = load(vehicle.img_path)
