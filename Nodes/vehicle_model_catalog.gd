extends Resource

class_name VehicleModelCatalog

@export var vehicle_models : Dictionary = {}

func get_vehicle_model(id : int) -> VehicleModel:
	if vehicle_models.has(id):
		return vehicle_models.get(id)
	else:
		return null
