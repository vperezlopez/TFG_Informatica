extends Control

@onready var vehicle_icon = $VBoxContainer/IconContainer/MarginContainer/VehicleIcon

@onready var label_name_value = $VBoxContainer/LabelsContainer/VBoxContainer/NameContainer/LabelNameValue
@onready var label_capacity_value = $VBoxContainer/LabelsContainer/VBoxContainer/CapacityContainer/LabelCapacityValue
@onready var label_speed_value = $VBoxContainer/LabelsContainer/VBoxContainer/SpeedContainer/LabelSpeedValue
@onready var label_cost_value = $VBoxContainer/LabelsContainer/VBoxContainer/CostContainer/LabelCostValue
@onready var label_price_value = $VBoxContainer/LabelsContainer/VBoxContainer/PriceContainer/LabelPriceValue

var vehicle_model : VehicleModel

func initialize(model : VehicleModel):
	vehicle_model = model
	vehicle_icon.texture = load(model.img_path)
	label_name_value.text = model.model_name
	label_capacity_value.text = str(model.capacity)
	label_speed_value.text = str(model.speed)
	label_cost_value.text = str(model.travel_cost)
	label_price_value.text = str(model.price)
