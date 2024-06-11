extends Control

signal button_clicked(const_button : Constants.ConstButtons)

func _on_button_factory_pressed():
	print_debug('Sending construction input')
	emit_signal('button_clicked', Constants.ConstButtons.FACTORY)

func _on_button_warehouse_pressed():
	print_debug('Sending construction input')
	emit_signal('button_clicked', Constants.ConstButtons.WAREHOUSE)

func _on_button_road_depot_pressed():
	print_debug('Sending construction input')
	emit_signal('button_clicked', Constants.ConstButtons.DEPOT_ROAD)

func _on_button_rail_depot_pressed():
	print_debug('Sending construction input')
	emit_signal('button_clicked', Constants.ConstButtons.DEPOT_RAILWAY)

func _on_button_road_pressed():
	print_debug('Sending construction input')
	emit_signal('button_clicked', Constants.ConstButtons.ROAD)

func _on_button_railway_pressed():
	print_debug('Sending construction input')
	emit_signal('button_clicked', Constants.ConstButtons.RAILWAY)

func _on_button_demolish_pressed():
	print_debug('Sending construction input')
	emit_signal('button_clicked', Constants.ConstButtons.DEMOLISH)

func _on_button_demolish_path_pressed():
	print_debug('Sending construction input')
	emit_signal('button_clicked', Constants.ConstButtons.DEMOLISH_PATH)
