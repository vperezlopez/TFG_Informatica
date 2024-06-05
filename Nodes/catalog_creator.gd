extends Node

class_name Catalog_Creator

static func create_catalog():
	var catalog = CargoCatalog.new()
	var cargo
	
	cargo = Cargo.new()
	cargo.id = 1
	cargo.name = "Wood"
	cargo.value = 2
	cargo.img_path = "res://images/" + cargo.name.to_lower() + "wood.png"
	catalog.cargos[cargo.id] = cargo
	
	cargo = Cargo.new()
	cargo.id = 2
	cargo.name = "Aluminium"
	cargo.value = 1.8
	cargo.img_path = "res://images/" + cargo.name.to_lower() + "wood.png"
	catalog.cargos[cargo.id] = cargo
	
	cargo = Cargo.new()
	cargo.id = 3
	cargo.name = "Steel"
	cargo.value = 2.4
	cargo.img_path = "res://images/" + cargo.name.to_lower() + "wood.png"
	catalog.cargos[cargo.id] = cargo
	
	cargo = Cargo.new()
	cargo.id = 4
	cargo.name = "Plastic"
	cargo.value = 1.2
	cargo.img_path = "res://images/" + cargo.name.to_lower() + "wood.png"
	catalog.cargos[cargo.id] = cargo
	
	cargo = Cargo.new()
	cargo.id = 5
	cargo.name = "Copper"
	cargo.value = 2.1
	cargo.img_path = "res://images/" + cargo.name.to_lower() + "wood.png"
	catalog.cargos[cargo.id] = cargo
	
	cargo = Cargo.new()
	cargo.id = 6
	cargo.name = "Fabric"
	cargo.value = 1.9
	cargo.img_path = "res://images/" + cargo.name.to_lower() + "wood.png"
	catalog.cargos[cargo.id] = cargo

	ResourceSaver.save(catalog, Constants.CARGO_CATALOG_PATH)
