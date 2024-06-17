extends HBoxContainer

func initialize(cargo : Cargo, quantity : int):
	#print_debug('Loading cargo: ' + str(cargo.name))
	$cargo_image.texture = load(cargo.img_path)
	$cargo_name.text = cargo.name
	$cargo_quantity.text = str(quantity)
