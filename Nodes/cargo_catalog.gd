extends Resource

class_name CargoCatalog

@export var cargos : Dictionary = {}

func get_cargo(id : int) -> Cargo:
	if cargos.has(id):
		return cargos.get(id)
	else:
		return null
