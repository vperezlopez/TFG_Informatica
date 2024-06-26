extends Resource

class_name CargoCatalog

@export var cargos : Dictionary = {}

func get_cargo(id : int) -> Cargo:
	if cargos.has(id):
		return cargos.get(id)
	else:
		return null

func get_cargo_from_name(n : String) -> Cargo:
	for cargo_id in cargos:
		if cargos[cargo_id].name == n:
			return cargos[cargo_id]
	push_error(n + ' is not a type of cargo!')
	return null

func get_duplicate() -> Dictionary:
	return cargos.duplicate(true)

func get_all_cargo() -> Array[Cargo]:
	var cargo_array: Array[Cargo] = []
	for key in cargos.keys():
		cargo_array.append(cargos[key])
	return cargo_array
	#return cargos.duplicate(true).keys()
