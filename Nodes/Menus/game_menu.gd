extends Control

signal exit_game()

func _on_button_exit_pressed():
	emit_signal("exit_game")
