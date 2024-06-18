extends Actor_Static

class_name Factory

const max_production_lines : int = 3

var input_storage : CargoStorage
var output_storage : CargoStorage
var production_lines : Array[ProductionLine]

var production_timers : Array[float]

func _ready():
	super._ready()
	demolishable = true
	sprite.texture = preload("res://Assets/Buildings/Factory.png")
	
	input_storage = CargoStorage.new()
	input_storage.init(200)
	output_storage = CargoStorage.new()
	output_storage.init(200)
	production_lines = []

func _process(delta):
	for i in range(production_lines.size()):
		if production_lines[i]:
			production_timers[i] += delta
			var production_line : ProductionLine = production_lines[i]
			var timer : float = production_timers[i]
			if timer > production_line.production_time:
				if can_produce(production_line):
					output_storage.add_cargo(production_line.output, 1)
					production_timers[i] -= production_line.production_time
				else:
					production_timers[i] = production_line.production_time

func unload_cargo(cargo : Cargo, quantity : int) -> int:
	return input_storage.add_cargo(cargo, quantity)

func load_cargo(cargo : Cargo, quantity : int) -> int:
	return output_storage.remove_cargo(cargo, quantity)

func can_produce(production_line : ProductionLine) -> bool:
	#CHECK CAPACITY: TODO
	for input_cargo in production_line.input:
		if !input_storage.has(input_cargo, production_line.input[input_cargo]):
			return false
	return true

func add_line(line : ProductionLine):
	production_lines.append(line)
	production_timers.append(0.0)

func remove_line(line : ProductionLine):
	var index = production_lines.find(line)
	production_lines.pop_at(index)
	production_timers.pop_at(index)

func set_production_lines(lines : Array[ProductionLine]):
	production_lines = lines
	
	production_timers = []
	for i in range(lines.size()):
		production_timers.append(0.0)
		
