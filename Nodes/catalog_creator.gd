extends Node

class_name Catalog_Creator

static func create_catalog():
	var catalog = CargoResource.new()

	var cargo1 = Cargo.new()
	cargo1.id = 1
	cargo1.name = "Wood"
	cargo1.value = 2
	cargo1.img_path = "res://images/wood.png"
	catalog.cargos[cargo1.id] = cargo1

	var cargo2 = Cargo.new()
	cargo2.id = 2
	cargo2.name = "Aluminium"
	cargo2.value = 1.8
	cargo2.img_path = "res://images/aluminium.png"
	catalog.cargos[cargo2.id] = cargo2

	var cargo3 = Cargo.new()
	cargo3.id = 3
	cargo3.name = "Steel"
	cargo3.value = 2.4
	cargo3.img_path = "res://images/steel.png"
	catalog.cargos[cargo3.id] = cargo3

	ResourceSaver.save(catalog, Constants.CATALOG_PATH)
