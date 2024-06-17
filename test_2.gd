extends Node2D

const VehicleModelCatalog = preload(Constants.VEHICLE_MODEL_CATALOG_PATH)

@onready var tile_map = $TileMap
@onready var vehicle = $vehicle
@onready var vehicle_2 = $vehicle2
@onready var city = $City
@onready var city_2 = $City2





# Called when the node enters the scene tree for the first time.
func _ready():
	
	vehicle.initialize(VehicleModelCatalog.get_vehicle_model(1))
	var operation1 = Operation.new()
	operation1.destination = city
	var route1 = Route.new()
	route1.add_operation(operation1)
	vehicle.route = route1
	
	vehicle_2.initialize(VehicleModelCatalog.get_vehicle_model(1))
	var operation2 = Operation.new()
	operation2.destination = city_2
	var route2 = Route.new()
	route2.add_operation(operation2)
	vehicle_2.route = route2
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
