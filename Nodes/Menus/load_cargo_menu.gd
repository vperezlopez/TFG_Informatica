extends Control

class_name LoadCargoMenu

const cargo_catalog = preload(Constants.CARGO_CATALOG_PATH) as CargoCatalog

@onready var cargo_select = $HBoxContainer/CargoSelect
@onready var quantity_box = $HBoxContainer/QuantityBox

signal remove_load(sender)

func initialize(options : Array[Cargo], cargo : Cargo, quantity : int):
	cargo_select.clear()
	
	for i in range(options.size()):
		var option = options[i]
		var texture = load(option.img_path)
		cargo_select.add_icon_item(texture, option.name, i)

	var selected_index = options.find(cargo)
	if selected_index != -1:
		cargo_select.selected = selected_index
	else:
		cargo_select.selected = 0

	quantity_box.value = quantity

func get_selected_cargo() -> Cargo:
	var selected_index = cargo_select.selected
	if selected_index != -1 and selected_index < cargo_select.item_count:
		return cargo_catalog.get_cargo_from_name(cargo_select.get_item_text(selected_index))
	return null

func get_selected_quantity() -> int:
	return quantity_box.value

func _on_button_delete_pressed():
	emit_signal("remove_load", self)
