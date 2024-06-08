extends Camera2D

var zoom_min = Vector2(.2, .2)
var zoom_max = Vector2(2, 2)
var zoom_step = Vector2(.2, .2)
var zoom_speed = .2
var new_zoom = zoom

var viewport_origin : Vector2 = Vector2(0.0, 0.0)
var viewport_size : Vector2

var left_margin : float
var right_margin : float
var top_margin : float
var bottom_margin : float

#var pos_min = Vector2(256, 128)
#var pos_max = Vector2(768, 384)
#var pos_max = Vector2(128, 128)
var pos_step = 16
var pos_speed = .1
var new_pos = position

# Only scroll when outside the central 80% of the screen
var mouse_margin = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	_calculate_margins()
	print(str(get_viewport().size))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if zoom != new_zoom:
		zoom = lerp(zoom, new_zoom, zoom_speed)
	if position != new_pos:
		position = lerp(position, new_pos, pos_speed)

	# Desplazamiento automático de la cámara basado en la posición del ratón
	_update_scroll_with_mouse(delta)

func _on_game_viewport_size_changed():
	print('Resizing camera_margin')
	_calculate_margins()
	#print('Viewport size: ' + str(viewport_size))
	#print('Left margin: ' + str(left_margin))
	#print('Right margin: ' + str(right_margin))
	#print('Top margin: ' + str(top_margin))
	#print('Bottom margin: ' + str(bottom_margin))

func _calculate_margins():
	#print(str(get_viewport()))
	#viewport_size = get_viewport().size
	get_viewport()
	#left_margin = viewport_size.x * mouse_margin
	#right_margin = viewport_size.x * (1 - mouse_margin)
	#top_margin = viewport_size.y * mouse_margin
	#bottom_margin = viewport_size.y * (1 - mouse_margin)
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			new_zoom = clamp(zoom + zoom_step, zoom_min, zoom_max)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			new_zoom = clamp(zoom - zoom_step, zoom_min, zoom_max)
		elif event.button_index == MOUSE_BUTTON_LEFT:
			#new_pos = get_global_mouse_position()
			pass
	
	if event is InputEventKey:
		if event.is_pressed():
			var move_dir = Vector2()
			if event.keycode == KEY_LEFT:
				move_dir.x -= pos_step
			if event.keycode == KEY_RIGHT:
				move_dir.x += pos_step
			if event.keycode == KEY_UP:
				move_dir.y -= pos_step
			if event.keycode == KEY_DOWN:
				move_dir.y += pos_step
			if move_dir != Vector2():
				new_pos += move_dir

# Actualiza la posición de la cámara basada en la posición del ratón
func _update_scroll_with_mouse(_delta):
	var mouse_pos = get_viewport().get_mouse_position()
	
	var move_dir = Vector2()		
	if _is_between(mouse_pos.x, viewport_origin.x, left_margin):
		move_dir.x = -pos_step * (1.0 - mouse_pos.x / left_margin)
	elif _is_between(mouse_pos.x, right_margin, viewport_size.x):
		move_dir.x = pos_step * (mouse_pos.x - right_margin) / left_margin
	if _is_between(mouse_pos.y, viewport_origin.y, top_margin):
		move_dir.y = -pos_step * (1.0 - mouse_pos.y / top_margin)
	elif _is_between(mouse_pos.y, bottom_margin, viewport_size.y):
		move_dir.y = pos_step * (mouse_pos.y - bottom_margin) / top_margin

	if move_dir != Vector2():
		#new_pos += move_dir * delta * pos_speed
		new_pos += move_dir

	#new_pos = new_pos.clamp(pos_min, pos_max - pos_min)

func _is_between(f : float, min : float, max : float) -> bool:
	return min < f and f < max

