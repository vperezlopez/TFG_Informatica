extends Control

var game_area
var game_menu

# Called when the node enters the scene tree for the first time.
func _ready():
	var w_size = get_window().size
	game_area = $VBoxContainer/game_area
	game_menu = $VBoxContainer/game_menu
	
	#game_area.custom_minimum_size.y = w_size.y * 0.8
	#game_menu.custom_minimum_size.y = w_size.y * 0.2
	
	print(w_size)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
