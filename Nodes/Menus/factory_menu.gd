extends Control

#@onready var input_storage_menu = $HBoxContainer/input_menu/ScrollContainer/input_storage
@onready var input_storage_list = $HBoxContainer/input_menu/ScrollContainer/input_storage_list
@onready var output_storage_list = $HBoxContainer/output_storage/ScrollContainer/output_storage_list
@onready var lines_container = $HBoxContainer/lines_menu/lines_container
@onready var button_add = $HBoxContainer/lines_menu/Control/ButtonAdd


const LINE_MENU = preload("res://Nodes/Menus/production_line_menu.tscn")
const CARGO_MENU = preload("res://Nodes/Menus/cargo_menu.tscn")

var factory : Factory
var _index : int
var _opened : int


signal close_factory_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	_index = 0
	_opened = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func initialize(f : Factory):
	clear()
	factory = f
	
	var production_lines = factory.production_lines.duplicate(true)
	
	for cargo in factory.input_storage.get_cargo():
		var quantity = factory.input_storage.get_quantity(cargo)
		var cargo_menu = CARGO_MENU.instantiate()
		cargo_menu.initialize(cargo, quantity)
		input_storage_list.add_child(cargo_menu)
	
	for cargo in factory.output_storage.get_cargo():
		var quantity = factory.output_storage.get_quantity(cargo)
		var cargo_menu = CARGO_MENU.instantiate()
		cargo_menu.initialize(cargo, quantity)
		output_storage_list.add_child(cargo_menu)
	
	for production_line in production_lines:
		add_line(production_line)

#func initialize_storage(input_storage : CargoStorage, output_storage : CargoStorage):
	#for cargo in input_storage.get_cargo():
		#var quantity = input_storage.get_quantity(cargo)
		#var cargo_menu = CARGO_MENU.instantiate()
		#cargo_menu.initialize(cargo, quantity)
		#input_storage_menu.add_child(cargo_menu)
		##print_debug(str(cargo))
	#pass

func clear():
	for child in input_storage_list.get_children():
		input_storage_list.remove_child(child)
		child.queue_free.call_deferred()
	for child in output_storage_list.get_children():
		output_storage_list.remove_child(child)
		child.queue_free.call_deferred()
	for child in lines_container.get_children():
		if child.get_child_count() > 0:
			var line_menu = child.get_child(0)
			child.remove_child(line_menu)
			line_menu.queue_free.call_deferred()
	_index = 0
	_opened = 0
	button_add.disabled = false

func add_line(production_line : ProductionLine = null):
	var line_menu = LINE_MENU.instantiate()
	lines_container.get_child(_index).add_child(line_menu)
	line_menu.initialize(production_line)
	
	line_menu.connect("accept_clicked", Callable(self, "_on_accept_clicked"))
	line_menu.connect("cancel_clicked", Callable(self, "_on_cancel_clicked"))
	line_menu.connect("remove_clicked", Callable(self, "_on_remove_clicked"))
	
	_index += 1
	if !production_line:
		_opened += 1
	update_add_button()

func remove_line(line_menu):
	var found_index = -1
	var children = lines_container.get_children()
	
	for i in range(children.size()):
		var slot = children[i]
		if line_menu in slot.get_children():
			slot.remove_child(line_menu)
			line_menu.queue_free()
			found_index = i
			_index -= 1
			break
	
	if found_index != -1:
		# Shift lines up
		for i in range(found_index, children.size() - 1):
			var current_slot = children[i]
			var next_slot = children[i + 1]
			
			if next_slot.get_child_count() > 0:
				var next_child = next_slot.get_child(0)
				next_slot.remove_child(next_child)
				current_slot.add_child(next_child)
			else:
				break
		
	update_add_button()

func update_add_button():
	if _index < factory.max_production_lines and !_opened:
		button_add.disabled = false
	else:
		button_add.disabled = true
		
	print('_index = ' + str(_index))
	print('_opened = ' + str(_opened))

func save_lines():
	var production_lines : Array[ProductionLine] = []
	for slot in lines_container.get_children():
		if slot.get_child(0):
			var line_menu = slot.get_child(0)
			if line_menu.production_line:
				production_lines.append(line_menu.production_line)
	factory.set_production_lines(production_lines)

func _on_button_add_pressed():
	add_line()
	#lines_container.add_child(line_menu)
	#line_menu.set_size_flags(Control.SIZE_EXPAND_FILL)
	#var size_ratio = 1.0 / float(factory.max_production_lines)
	#line_menu.set_v_size_flags(Control.SIZE_EXPAND_FILL)
	#line_menu.custom_minimum_size = Vector2(0, size_ratio * lines_container.size.y)

		#child.set_size_flags(Control.SIZE_EXPAND_FILL)
		#var min_size = Vector2(0, 0)  # Puedes ajustar esto si necesitas un tamaño mínimo
		#child.min_size = min_size
		#
		#child
		#child
	#
	
	
	
	pass # Replace with function body.




func _on_button_accept_pressed():
	save_lines()
	emit_signal("close_factory_menu")


func _on_button_cancel_pressed():
	emit_signal("close_factory_menu")


# PRODUCTION LINE MENU SIGNALS
func _on_accept_clicked():
	_opened -= 1
	update_add_button()

func _on_cancel_clicked(sender):
	_opened -= 1
	remove_line(sender)
	

func _on_remove_clicked(sender):
	remove_line(sender)
	
