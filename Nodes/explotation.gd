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



#func _on_input_event(_viewport, event, _shape_idx):
	#if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		#open_menu()
#
#func open_menu():
	#pass

