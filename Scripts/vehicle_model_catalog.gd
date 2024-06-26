extends Resource

class_name VehicleModelCatalog

@export var vehicle_models : Dictionary = {}

func get_vehicle_model(id : int) -> VehicleModel:
	if vehicle_models.has(id):
		return vehicle_models.get(id)
	else:
		return null

func get_vehicle_model_with_navigation(nav : int) -> Array[VehicleModel]:
	var res : Array[VehicleModel] = []
	for vehicle_model_id in vehicle_models:
		var vehicle_model = get_vehicle_model(vehicle_model_id)
		if vehicle_model.navigation == nav:
			res.append(vehicle_model)
	return res
