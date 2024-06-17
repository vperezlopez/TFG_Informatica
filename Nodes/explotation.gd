extends Actor_Static

class_name Explotation

var explotation_type : ExplotationType
var cargo_storage : CargoStorage

func _ready():
	super._ready()
	demolishable = false
	sprite.texture = preload("res://Assets/Placeholder_1.png")
	
	cargo_storage = CargoStorage.new()

func initialize(type : ExplotationType):
	var q = 100
	explotation_type = type
	loc_name = type.explotation_name
	label.text = loc_name
	cargo_storage.init(q * explotation_type.output.size())
	for cargo in explotation_type.output:
		cargo_storage.add_cargo(cargo, q)
	sprite.texture = load(type.img_path)


func load_cargo(cargo : Cargo, quantity : int) -> int:
	print(str(cargo.name) + ' available: ' + str(cargo_storage.get_quantity(cargo)))
	var removed = cargo_storage.remove_cargo(cargo, quantity)
	print(str(cargo.name) + ' removed: ' + str(removed))
	print(str(cargo))
	var inventory = cargo_storage.get_inventory()
	for tuple in inventory:
		print(str(tuple[0] as Cargo))
		print(str(tuple[0]) + ', ' + str(tuple[1]))
	return removed

#func _on_input_event(_viewport, event, _shape_idx):
	#if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		#open_menu()
#
#func open_menu():
	#pass

