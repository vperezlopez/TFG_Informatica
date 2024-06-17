extends Control

class_name DestinationMenu

@onready var background = $Background
@onready var arrows_container = $HBoxContainer/ArrowsContainer
@onready var button_up = $HBoxContainer/ArrowsContainer/ButtonUp
@onready var button_down = $HBoxContainer/ArrowsContainer/ButtonDown
@onready var button_find = $HBoxContainer/ButtonFind
@onready var building_icon = $HBoxContainer/BuildingIcon
@onready var label_name = $HBoxContainer/LabelName
@onready var icons_container = $HBoxContainer/IconsContainer
@onready var load_icon = $HBoxContainer/IconsContainer/LoadIcon
@onready var unload_icon = $HBoxContainer/IconsContainer/UnloadIcon
@onready var button_remove = $HBoxContainer/ButtonRemove

var operation : Operation

signal up_clicked(sender)
signal down_clicked(sender)
signal edit_clicked(sender)
signal find_clicked(pos)
signal remove_clicked(sender)

func initialize(operation : Operation):
	self.operation = operation
	building_icon.texture = operation.get_destination().sprite.texture
	label_name.text = operation.get_destination().loc_name

func get_operation():
	return operation

func highlight(highlighted : bool):
	if highlighted:
		background.color = '#f6f7f7'
	else:
		background.color = '#beefc2'

func _on_button_up_pressed():
	emit_signal("up_clicked", self)

func _on_button_down_pressed():
	emit_signal("down_clicked", self)

func _on_button_edit_load_pressed():
	emit_signal("edit_clicked", self)

func _on_button_find_pressed():
	emit_signal("find_clicked", operation.get_destination().position)

func _on_button_remove_pressed():
	emit_signal("remove_clicked", self)
