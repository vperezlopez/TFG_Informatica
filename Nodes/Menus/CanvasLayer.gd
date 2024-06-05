extends CanvasLayer
@onready var main = $Main
@onready var load = $Load
@onready var settings = $Settings





func _on_button_play_pressed():
	get_tree().change_scene_to_file("res://Nodes/world.tscn")


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





