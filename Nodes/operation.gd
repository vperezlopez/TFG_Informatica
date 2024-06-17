extends Object

class_name Operation

var destination : Actor_Static

var wait_load : bool
var load_dict : Dictionary
var unload_dict : Dictionary

func initialize(dest : Actor_Static, wait : bool = false):
	destination = dest
	load_dict = {}
	unload_dict = {}
	wait_load = wait
	

func get_destination() -> Actor_Static:
	return destination

func get_destination_pos() -> Vector2:
	return destination.position

func get_load_duplicate() -> Dictionary:
	return load_dict.duplicate(true)

func get_unload_duplicate() -> Dictionary:
	return unload_dict.duplicate(true)

#func get_load_list() -> Array[Cargo]:
	#return load_dict.keys()
#
#func get_unload_list() -> Array[Cargo]:
	#return unload_dict.keys()
	#
#func get_load_quantity(cargo : Cargo) -> int:
	#if load_dict.has(cargo):
		#return load_dict[cargo]
	#else:
		#return -1
#
#func get_unload_quantity(cargo : Cargo) -> int:
	#if unload_dict.has(cargo):
		#return unload_dict[cargo]
	#else:
		#return -1

func get_wait_load() -> bool:
	return wait_load

func add_load_cargo(cargo : Cargo, q : int):
	if load_dict.has(cargo):
		load_dict[cargo] += q
	else:
		load_dict[cargo] = q

func add_unload_cargo(cargo : Cargo, q : int):
	if unload_dict.has(cargo):
		unload_dict[cargo] += q
	else:
		unload_dict[cargo] = q
		

func remove_load_cargo(cargo : Cargo) -> int:
	var res
	if load_dict.has(cargo):
		res = load_dict[cargo]
		load_dict.erase(cargo)
		return res
	else:
		push_error('Attempted to delete inexistent cargo in Operation class')
		return -99

func remove_unload_cargo(cargo : Cargo) -> int:
	var res
	if unload_dict.has(cargo):
		res = unload_dict[cargo]
		unload_dict.erase(cargo)
		return res
	else:
		push_error('Attempted to delete inexistent cargo in Operation class')
		return -99
		
func set_wait_load(b : bool):
	wait_load = b


func set_load_dict(ld : Dictionary):
	load_dict = ld


func set_unload_dict(ud : Dictionary):
	unload_dict = ud
