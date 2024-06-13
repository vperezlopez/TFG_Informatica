extends Resource

class_name ExplotationTypeCatalog

@export var explotation_types : Dictionary = {}

func get_explotation_type(id : int) -> ExplotationType:
	if explotation_types.has(id):
		return explotation_types.get(id)
	else:
		return null
