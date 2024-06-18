extends Control

signal back_to_game
signal back_to_main
signal back_to_desktop

func _on_button_back_pressed():
	emit_signal("back_to_game")

func _on_button_main_menu_pressed():
	emit_signal("back_to_main")

func _on_button_desktop_pressed():
	emit_signal("back_to_desktop")
