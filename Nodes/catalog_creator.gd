extends Resource

class_name Catalog_Creator

static func create_catalogs():
	create_cargo_catalog()
	create_vehicle_model_catalog()
	create_explotation_type_catalog()
	create_production_line_catalog()

static func create_cargo_catalog():
	var catalog = CargoCatalog.new()
	var cargo
	
	cargo = Cargo.new()
	cargo.id = 1
	cargo.name = "Wood"
	cargo.value = 275
	cargo.img_path = "res://Assets/Cargo/" + cargo.name.to_lower() + ".png"
	catalog.cargos[cargo.id] = cargo
	
	cargo = Cargo.new()
	cargo.id = 2
	cargo.name = "Aluminium"
	cargo.value = 2750
	cargo.img_path = "res://Assets/Cargo/" + cargo.name.to_lower() + ".png"
	catalog.cargos[cargo.id] = cargo
	
	cargo = Cargo.new()
	cargo.id = 3
	cargo.name = "Steel"
	cargo.value = 1250
	cargo.img_path = "res://Assets/Cargo/" + cargo.name.to_lower() + ".png"
	catalog.cargos[cargo.id] = cargo
	
	cargo = Cargo.new()
	cargo.id = 4
	cargo.name = "Plastic"
	cargo.value = 750
	cargo.img_path = "res://Assets/Cargo/" + cargo.name.to_lower() + ".png"
	catalog.cargos[cargo.id] = cargo
	
	cargo = Cargo.new()
	cargo.id = 5
	cargo.name = "Copper"
	cargo.value = 7500
	cargo.img_path = "res://Assets/Cargo/" + cargo.name.to_lower() + ".png"
	catalog.cargos[cargo.id] = cargo
	
	cargo = Cargo.new()
	cargo.id = 6
	cargo.name = "Fabric"
	cargo.value = 1500
	cargo.img_path = "res://Assets/Cargo/" + cargo.name.to_lower() + ".png"
	catalog.cargos[cargo.id] = cargo
	
	cargo = Cargo.new()
	cargo.id = 7
	cargo.name = "Furniture"
	cargo.value = 3000
	cargo.img_path = "res://Assets/Cargo/" + cargo.name.to_lower() + ".png"
	catalog.cargos[cargo.id] = cargo
	
	cargo = Cargo.new()
	cargo.id = 8
	cargo.name = "Toys"
	cargo.value = 1750
	cargo.img_path = "res://Assets/Cargo/" + cargo.name.to_lower() + ".png"
	catalog.cargos[cargo.id] = cargo
	
	cargo = Cargo.new()
	cargo.id = 9
	cargo.name = "Tools"
	cargo.value = 2250
	cargo.img_path = "res://Assets/Cargo/" + cargo.name.to_lower() + ".png"
	catalog.cargos[cargo.id] = cargo
	
	cargo = Cargo.new()
	cargo.id = 10
	cargo.name = "Blankets"
	cargo.value = 2400
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
	vehicle_model.speed = 30
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
	vehicle_model.speed = 24
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
	explotation_type.img_path = Constants.PATH_ASSETS_EXPLOTATIONS + Constants.EXPLOTATION_TYPE_PREFIX + Utils.name_to_file_name(explotation_type.explotation_name) + Constants.ASSET_FORMAT
	catalog.explotation_types[explotation_type.id] = explotation_type
	
	
	
	explotation_type = ExplotationType.new()
	explotation_type.id = 2
	explotation_type.explotation_name = "Steel Mill"
	explotation_type.output = [
		cargo_catalog.get_cargo_from_name("Steel") as Cargo,
		cargo_catalog.get_cargo_from_name("Aluminium") as Cargo,
		cargo_catalog.get_cargo_from_name("Copper") as Cargo
	]
	explotation_type.img_path = Constants.PATH_ASSETS_EXPLOTATIONS + Constants.EXPLOTATION_TYPE_PREFIX + Utils.name_to_file_name(explotation_type.explotation_name) + Constants.ASSET_FORMAT
	catalog.explotation_types[explotation_type.id] = explotation_type



	explotation_type = ExplotationType.new()
	explotation_type.id = 3
	explotation_type.explotation_name = "Textile Mill"
	explotation_type.output = [
		cargo_catalog.get_cargo_from_name("Fabric") as Cargo
	]
	explotation_type.img_path = Constants.PATH_ASSETS_EXPLOTATIONS + Constants.EXPLOTATION_TYPE_PREFIX + Utils.name_to_file_name(explotation_type.explotation_name) + Constants.ASSET_FORMAT
	catalog.explotation_types[explotation_type.id] = explotation_type
	
	
	
	explotation_type = ExplotationType.new()
	explotation_type.id = 4
	explotation_type.explotation_name = "Refinery"
	explotation_type.output = [
		cargo_catalog.get_cargo_from_name("Plastic") as Cargo
	]
	explotation_type.img_path = Constants.PATH_ASSETS_EXPLOTATIONS + Constants.EXPLOTATION_TYPE_PREFIX + Utils.name_to_file_name(explotation_type.explotation_name) + Constants.ASSET_FORMAT
	catalog.explotation_types[explotation_type.id] = explotation_type
	
	ResourceSaver.save(catalog, Constants.EXPLOTATION_TYPE_CATALOG_PATH)

static func create_production_line_catalog():
	var cargo_catalog = load(Constants.CARGO_CATALOG_PATH) as CargoCatalog
	#var production_line_catalog = load(Constants.PRODUCTION_LINE_CATALOG_PATH) as ProductionLineCatalog
	
	var catalog = ProductionLineCatalog.new()
	var production_line
	
	production_line = ProductionLine.new()
	production_line.id = 1
	production_line.input = {
		cargo_catalog.get_cargo_from_name("Wood"): 2
	}
	production_line.output = cargo_catalog.get_cargo_from_name("Furniture")
	#var c : Cargo = cargo_catalog.get_cargo_from_name("Furniture")
	#production_line.output = c
	#print(cargo_catalog.get_cargo_from_name("Furniture"))
	#print(production_line.output)

	production_line.production_time = 2.0
	
	catalog.production_lines[production_line.id] = production_line
	
	
	
	production_line = ProductionLine.new()
	production_line.id = 2
	production_line.input = {
		cargo_catalog.get_cargo_from_name("Plastic"): 1
	}
	production_line.output = cargo_catalog.get_cargo_from_name("Toys")
	production_line.production_time = 0.6
	
	catalog.production_lines[production_line.id] = production_line
	
	
	
	production_line = ProductionLine.new()
	production_line.id = 3
	production_line.input = {
		cargo_catalog.get_cargo_from_name("Steel"): 1
	}
	production_line.output = cargo_catalog.get_cargo_from_name("Tools")
	production_line.production_time = 1.3
	
	catalog.production_lines[production_line.id] = production_line
	
	production_line = ProductionLine.new()
	production_line.id = 4
	production_line.input = {
		cargo_catalog.get_cargo_from_name("Fabric"): 1
	}
	production_line.output = cargo_catalog.get_cargo_from_name("Blankets")
	production_line.production_time = 0.9
	
	catalog.production_lines[production_line.id] = production_line

	ResourceSaver.save(catalog, Constants.PRODUCTION_LINE_CATALOG_PATH)
