extends HBoxContainer

@onready var arrows_container = $ArrowsContainer
@onready var button_up = $ArrowsContainer/ButtonUp
@onready var button_down = $ArrowsContainer/ButtonDown
@onready var button_find = $ButtonFind
@onready var label_name = $LabelName
@onready var icons_container = $IconsContainer
@onready var load_icon = $IconsContainer/LoadIcon
@onready var unload_icon = $IconsContainer/UnloadIcon
@onready var button_remove = $ButtonRemove

var destination : Actor_Static

signal up_clicked(sender)
signal down_clicked(sender)
signal find_clicked(position)
signal remove_clicked(sender)


func initialize(actor_static : Actor_Static):
	destination = actor_static
	label_name.text = destination.loc_name


func _on_button_up_pressed():
	emit_signal("up_clicked", self)

func _on_button_down_pressed():
	emit_signal("down_clicked", self)

func _on_button_find_pressed():
	emit_signal("find_clicked", destination.position)

func _on_button_remove_pressed():
	emit_signal("remove_clicked", self)
