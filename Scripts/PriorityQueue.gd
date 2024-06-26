extends RefCounted

class_name PriorityQueue

var elements = []

# Función de comparación
func _compare(a, b):
	return a["priority"] < b["priority"]

func push(item, priority):
	elements.append({"item": item, "priority": priority})
	elements.sort_custom(Callable(self, "_compare"))

func pop():
	return elements.pop_front().item

func empty():
	return elements.is_empty()
