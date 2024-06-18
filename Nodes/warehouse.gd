extends Actor_Static

class_name Warehouse

var cargo_storage : CargoStorage

func _ready():
	super._ready()
	demolishable = true
	sprite.texture = preload("res://Assets/Buildings/Warehouse.png")
	
	cargo_storage = CargoStorage.new()
	cargo_storage.init(200)

func unload_cargo(cargo : Cargo, quantity : int) -> int:
	return cargo_storage.add_cargo(cargo, quantity)

func load_cargo(cargo : Cargo, quantity : int) -> int:
	return cargo_storage.remove_cargo(cargo, quantity)

#func _on_input_event(_viewport, event, _shape_idx):
	#if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		#open_menu()
#
#func open_menu():
	#pass
