extends Node

class_name Catalog_Creator

static func create_catalogs():
	create_cargo_catalog()
	create_vehicle_model_catalog()
	create_explotation_type_catalog()

static func create_cargo_catalog():
	var catalog = CargoCatalog.new()
	var cargo
	
	cargo = Cargo.new()
	cargo.id = 1
	cargo.name = "Wood"
	cargo.value = 2
	cargo.img_path = "res://Assets/Cargo/" + cargo.name.to_lower() + ".png"
	catalog.cargos[cargo.id] = cargo
	
	cargo = Cargo.new()
	cargo.id = 2
	cargo.name = "Aluminium"
	cargo.value = 1.8
	cargo.img_path = "res://Assets/Cargo/" + cargo.name.to_lower() + ".png"
	catalog.cargos[cargo.id] = cargo
	
	cargo = Cargo.new()
	cargo.id = 3
	cargo.name = "Steel"
	cargo.value = 2.4
	cargo.img_path = "res://Assets/Cargo/" + cargo.name.to_lower() + ".png"
	catalog.cargos[cargo.id] = cargo
	
	cargo = Cargo.new()
	cargo.id = 4
	cargo.name = "Plastic"
	cargo.value = 1.2
	cargo.img_path = "res://Assets/Cargo/" + cargo.name.to_lower() + ".png"
	catalog.cargos[cargo.id] = cargo
	
	cargo = Cargo.new()
	cargo.id = 5
	cargo.name = "Copper"
	cargo.value = 2.1
	cargo.img_path = "res://Assets/Cargo/" + cargo.name.to_lower() + ".png"
	catalog.cargos[cargo.id] = cargo
	
	cargo = Cargo.new()
	cargo.id = 6
	cargo.name = "Fabric"
	cargo.value = 1.9
	cargo.img_path = "res://Assets/Cargo/" + cargo.name.to_lower() + ".png"
	catalog.cargos[cargo.id] = cargo

	ResourceSaver.save(catalog, Constants.CARGO_CATALOG_PATH)



static func create_vehicle_model_catalog():
	var catalog = VehicleModelCatalog.new()
	var vehicle_model
	
	vehicle_model = VehicleModel.new()
	vehicle_model.id = 1
	
	vehicle_model.navigation = Constants.Navigation.ROAD

	vehicle_model.model_name = 'Truck'

	vehicle_model.capacity = 1
	vehicle_model.speed = 10
	vehicle_model.travel_cost = 10
	vehicle_model.price = 10000
	
	vehicle_model.img_path = "res://Assets/Vehicle_Models/" + vehicle_model.model_name.to_lower() + ".png"
	catalog.vehicle_models[vehicle_model.id] = vehicle_model

	#########################################################################################

	vehicle_model = VehicleModel.new()
	vehicle_model.id = 2
	
	vehicle_model.navigation = Constants.Navigation.ROAD

	vehicle_model.model_name = 'Trailer'

	vehicle_model.capacity = 2
	vehicle_model.speed = 8
	vehicle_model.travel_cost = 14
	vehicle_model.price = 32000
	
	vehicle_model.img_path = "res://Assets/Vehicle_Models/" + vehicle_model.model_name.to_lower() + ".png"
	catalog.vehicle_models[vehicle_model.id] = vehicle_model

	ResourceSaver.save(catalog, Constants.VEHICLE_MODEL_CATALOG_PATH)


static func create_explotation_type_catalog():
	var cargo_catalog = load(Constants.CARGO_CATALOG_PATH) as CargoCatalog
	
	var catalog = ExplotationTypeCatalog.new()
	var explotation_type
	
	explotation_type = ExplotationType.new()
	explotation_type.id = 1
	explotation_type.explotation_name = "Sawmill"
	explotation_type.output = [
		cargo_catalog.get_cargo_from_name("Wood") as Cargo
	]
	explotation_type.img_path = Constants.PATH_ASSETS_BUILDINGS + Constants.EXPLOTATION_TYPE_PREFIX + Utils.name_to_file_name(explotation_type.explotation_name) + Constants.ASSET_FORMAT
	catalog.explotation_types[explotation_type.id] = explotation_type
	
	
	
	explotation_type = ExplotationType.new()
	explotation_type.id = 2
	explotation_type.explotation_name = "Steel Mill"
	explotation_type.output = [
		cargo_catalog.get_cargo_from_name("Steel") as Cargo,
		cargo_catalog.get_cargo_from_name("Aluminium") as Cargo,
		cargo_catalog.get_cargo_from_name("Copper") as Cargo
	]
	explotation_type.img_path = Constants.PATH_ASSETS_BUILDINGS + Constants.EXPLOTATION_TYPE_PREFIX + Utils.name_to_file_name(explotation_type.explotation_name) + Constants.ASSET_FORMAT
	catalog.explotation_types[explotation_type.id] = explotation_type



	explotation_type = ExplotationType.new()
	explotation_type.id = 3
	explotation_type.explotation_name = "Textile Mill"
	explotation_type.output = [
		cargo_catalog.get_cargo_from_name("Fabric") as Cargo
	]
	explotation_type.img_path = Constants.PATH_ASSETS_BUILDINGS + Constants.EXPLOTATION_TYPE_PREFIX + Utils.name_to_file_name(explotation_type.explotation_name) + Constants.ASSET_FORMAT
	catalog.explotation_types[explotation_type.id] = explotation_type
	
	
	
	explotation_type = ExplotationType.new()
	explotation_type.id = 4
	explotation_type.explotation_name = "Refinery"
	explotation_type.output = [
		cargo_catalog.get_cargo_from_name("Plastic") as Cargo
	]
	explotation_type.img_path = Constants.PATH_ASSETS_BUILDINGS + Constants.EXPLOTATION_TYPE_PREFIX + Utils.name_to_file_name(explotation_type.explotation_name) + Constants.ASSET_FORMAT
	catalog.explotation_types[explotation_type.id] = explotation_type
	
	ResourceSaver.save(catalog, Constants.EXPLOTATION_TYPE_CATALOG_PATH)
