extends CanvasLayer
@onready var main = $Main
@onready var load = $Load
@onready var settings = $Settings
@onready var new = $New

@onready var spin_box_width = $New/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainerMapSize/SpinBoxWidth
@onready var spin_box_height = $New/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainerMapSize/SpinBoxHeight
@onready var spin_box_cities = $New/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainerCities/SpinBoxCities
@onready var spin_box_explotations = $New/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainerExplotations/SpinBoxExplotations
@onready var spin_box_harbors = $New/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainerHarbors/SpinBoxHarbors



func _on_button_new_pressed():
	_goto(new)


func _on_button_play_pressed():
	var world = load("res://Nodes/world.tscn").instantiate()
	world.new_game(Vector2i(spin_box_width.value, spin_box_height.value), spin_box_cities.value, spin_box_explotations.value, spin_box_harbors.value)
	get_tree().root.add_child(world)
	queue_free()
	#get_tree().change_scene_to_file("res://Nodes/world.tscn")


func _on_button_load_pressed():
	_goto(load)


func _on_button_settings_pressed():
	_goto(settings)


func _on_button_back_pressed():
	_goto(main)


func _on_button_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.
	
func _goto(menu : Control):
	for child in get_children():
		child.visible = (child == menu)
	#menu.visible = true

