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

var destination : Actor_Static

#signal destination_selected(sender)

signal up_clicked(sender)
signal down_clicked(sender)
signal edit_clicked(sender)
signal find_clicked(position)
signal remove_clicked(sender)


func initialize(actor_static : Actor_Static):
	destination = actor_static
	building_icon.texture = actor_static.sprite.texture
	label_name.text = destination.loc_name

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
	emit_signal("find_clicked", destination.position)

func _on_button_remove_pressed():
	emit_signal("remove_clicked", self)


#func _on_gui_input(event):
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#emit_signal("destination_selected", self)
