extends Control

@onready var vehicle_info = $VBoxContainer/vehicle_info

signal buy_button_pressed(vehicle_model : VehicleModel)

func initialize(vehicle_model : VehicleModel):
	vehicle_info.initialize(vehicle_model)


func _on_button_buy_pressed():
	emit_signal("buy_button_pressed", vehicle_info.vehicle_model)
	pass # Replace with function body.
