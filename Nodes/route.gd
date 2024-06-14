extends Object

class_name Route

var operations : Array[Operation]

func initialize():
	operations = []

func get_operations_size():
	return operations.size()

func get_operation(i : int) -> Operation:
	return operations[i]

func add_operation(operation : Operation):
	operations.append(operation)

func remove_operation(operation : Operation):
	operations.pop_at(operations.find(operation))

func remove_operation_index(i : int):
	operations.pop_at(i)

func get_destinations() -> Array[Actor_Static]:
	var res : Array[Actor_Static] = []
	for operation in operations:
		res.append(operation.get_destination())
	return res

func get_destinations_pos() -> Array[Vector2]:
	var res = []
	for operation in operations:
		res.append(operation.get_destination_pos())
	return res
