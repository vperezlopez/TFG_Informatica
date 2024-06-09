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
	# We do not use the _calculate_margins function here, because it does not have access to the viewport yet.
	# It automatically calculates them the moment the viewport is available and recieves the signal in _on_game_viewport_size_changed()
	pass

func set_starting_position(pos : Vector2):
	new_pos = pos
	position = pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if zoom != new_zoom:
		zoom = lerp(zoom, new_zoom, zoom_speed)
	if position != new_pos:
		position = lerp(position, new_pos, pos_speed)

	# Calculate where the camera should move to
	_update_scroll_with_mouse(delta)

func _on_game_viewport_size_changed():
	_calculate_margins()

func _calculate_margins():
	var viewport = get_viewport()
	if viewport:
		# Viewport available
		viewport_size = viewport.size
		left_margin = viewport_size.x * mouse_margin
		right_margin = viewport_size.x * (1 - mouse_margin)
		top_margin = viewport_size.y * mouse_margin
		bottom_margin = viewport_size.y * (1 - mouse_margin)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			# Zoom in
			new_zoom = clamp(zoom + zoom_step, zoom_min, zoom_max)
			# PENDING: scroll to the point where the player zooms in
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			# Zoom out
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

# Updates the new position the camera should be at. It is later compuited in the _process func using linear interpolation
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

