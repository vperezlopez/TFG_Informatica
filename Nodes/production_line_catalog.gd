extends Resource

class_name ProductionLineCatalog

@export var production_lines : Dictionary = {}

func get_production_line(id : int) -> ProductionLine:
	if production_lines.has(id):
		return production_lines.get(id)
	else:
		return null

func get_production_line_from_output(output : Cargo) -> ProductionLine:
	for production_line_id in production_lines:
		var production_line = get_production_line(production_line_id)
		if production_line.output == output:
			return production_line
	return null
