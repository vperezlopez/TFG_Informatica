extends Resource

class_name ExplotationTypeCatalog

@export var explotation_types : Dictionary = {}

func get_explotation_type(id : int) -> ExplotationType:
	if explotation_types.has(id):
		return explotation_types.get(id)
	else:
		return null

func get_random_explotation_type() -> ExplotationType:
	var id = (randi() % explotation_types.size()) + 1
	if explotation_types.has(id):
		return explotation_types.get(id)
	else:
		push_error('Could not get a random explotation type!')
		return null
