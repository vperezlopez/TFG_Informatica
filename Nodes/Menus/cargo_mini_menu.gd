extends VBoxContainer

const CARGO_MENU = preload("res://Nodes/Menus/cargo_menu.tscn")

func initialize(expl : Explotation):
	for child in get_children():
		child.queue_free.call_deferred()
	
	initialize_storage(expl.cargo_storage)

func initialize_storage(cs : CargoStorage):
	for cargo in cs.get_cargo():
		var quantity = cs.get_quantity(cargo)
		var cargo_menu = CARGO_MENU.instantiate()
		add_child(cargo_menu)
		cargo_menu.initialize(cargo, quantity)
	pass
