extends Control

const cargo_catalog = preload(Constants.CARGO_CATALOG_PATH) as CargoCatalog
const production_line_catalog = preload(Constants.PRODUCTION_LINE_CATALOG_PATH) as ProductionLineCatalog

const CARGO_MENU = preload("res://Nodes/Menus/cargo_menu.tscn")

@onready var input_box = $HBoxContainer/InputContainer/MarginContainer/ScrollContainer/InputBox

@onready var label_time = $HBoxContainer/SeparatorContainer/VBoxContainer/LabelTime

@onready var output_selector_container = $HBoxContainer/OutputContainer/OutputSelectorContainer

@onready var output_selector = $HBoxContainer/OutputContainer/OutputSelectorContainer/VBoxContainer/OutputSelector
@onready var button_accept = $HBoxContainer/OutputContainer/OutputSelectorContainer/VBoxContainer/HBoxContainer/ButtonAccept
@onready var button_cancel = $HBoxContainer/OutputContainer/OutputSelectorContainer/VBoxContainer/HBoxContainer/ButtonCancel

@onready var output_display_container = $HBoxContainer/OutputContainer/OutputDisplayContainer

@onready var icon_output = $HBoxContainer/OutputContainer/OutputDisplayContainer/VBoxContainer/HBoxContainer/IconOutput
@onready var label_output = $HBoxContainer/OutputContainer/OutputDisplayContainer/VBoxContainer/HBoxContainer/LabelOutput

@onready var button_remove = $HBoxContainer/OutputContainer/OutputDisplayContainer/VBoxContainer/ButtonRemove

var production_line : ProductionLine

signal accept_clicked
signal cancel_clicked(sender)
signal remove_clicked(sender)

# Called when the node enters the scene tree for the first time.
func _ready():
	for production_line : ProductionLine in production_line_catalog.get_all_production_lines():
		var id : int = production_line.id
		var output : Cargo = production_line.output
		var output_name = output.name
		var output_texture = load(output.img_path)
		output_selector.add_icon_item((output_texture), output_name, id)
	pass
	
func initialize(pl : ProductionLine = null):
	clear()
	
	if pl:
		output_selector_container.visible = false
		output_display_container.visible = true
		production_line = pl
		for cargo in pl.input:
			var cargo_menu = CARGO_MENU.instantiate()
			input_box.add_child(cargo_menu)
			var quantity = pl.input[cargo]
			cargo_menu.initialize(cargo, quantity)
		label_time.text = str(pl.production_time)
		icon_output.texture = load(pl.output.img_path)
		label_output.text = pl.output.name
	else:
		#var pls = production_line_catalog.get_all_production_lines()
		
		#var selected_index = 1
		#output_selector.selected = selected_index
		output_selector_container.visible = true
		output_display_container.visible = false
		
	
func clear():
	for child in input_box.get_children():
		input_box.remove_child(child)
		child.queue_free.call_deferred()
	label_time.text = ""
	

func _on_button_accept_pressed():
	var pl = production_line_catalog.get_production_line(output_selector.get_selected() + 1)
	initialize(pl)
	emit_signal("accept_clicked")

func _on_button_cancel_pressed():
	emit_signal("cancel_clicked", self)

func _on_button_remove_pressed():
	emit_signal("remove_clicked", self)
