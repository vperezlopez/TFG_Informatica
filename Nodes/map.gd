extends TileMap

var altitude = FastNoiseLite.new()
var map_width = 0
var map_height = 0

var base_grass = Vector2i(0, 1)
var alternative_grass := [
	Vector2i(1, 1),
	Vector2i(2, 1),
	Vector2i(3, 1),
	Vector2i(0, 3),
	Vector2i(1, 3),
	Vector2i(2, 3)
]
var alternative_grass_chance = 0.06

var debug_enabled = false

var occupied_tiles : Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_map(get_parent().map_width, get_parent().map_height)


func generate_map(width : int, height : int):
	map_width = width
	map_height = height
	for x in range (width):
		for y in range (floor(height/2)):
			set_cell(0, Vector2i(x, y), 1, Vector2i(0, 3))


func _process(delta):
	if debug_enabled:
		var world_pos = get_global_mouse_position()
		var map_pos = local_to_map(world_pos)
		$CursorLabel.position = get_global_mouse_position()
		$CursorLabel.text = "Tile Coordinates: (" + str(map_pos.x) + ", " + str(map_pos.y + 1) + ")\n" + \
							"Global Position: (" + str(roundf(world_pos.x)) + ", " + str(roundf(world_pos.y)) + ")"

func place_actor_static(actor_static_instance : Actor_Static, pos : Vector2i = Vector2i(-1, -1)):
	if pos == Vector2i(-1, -1):
		pos = get_random_pos()
	if valid_position(pos[0], pos[1]):
		actor_static_instance.position = map_to_local(pos)
		occupied_tiles[pos] = actor_static_instance

func get_random_pos() -> Vector2i:
	var rand_x = -1
	var rand_y = -1
	while(!valid_position(rand_x, rand_y)):
		rand_x = randi() % map_width
		rand_y = randi() % (map_height / 2)
	return Vector2i(rand_x, rand_y)

func valid_position(x : int, y : int) -> bool :
	if occupied_tiles.has(Vector2i(x, y)):
		return false
	return x > -1 and y > -1
