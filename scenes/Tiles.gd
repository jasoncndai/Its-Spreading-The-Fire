extends TileMap

var fire_sprite = preload("res://scenes/fire.tscn")

var mouse_pos
var tile_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed("MOUSE_RIGHT"):
		mouse_pos = get_viewport().get_mouse_position()
		tile_pos = local_to_map(mouse_pos)
		print(mouse_pos)
		print(tile_pos)
		#var tile_data = get_cell_tile_data(0, tile_pos)
	#
		#if tile_data is TileData:
			#print(tile_data.get_custom_data("Name"))           
		spawn_fire(tile_pos)
		
func spawn_fire(pos):
	var fire = fire_sprite.instantiate()
	fire.position = pos*16
	add_child(fire)

# Check children node entering tileset, if it is Fire, let burn, spread and then extinguish
func _on_child_entered_tree(node):
	if node is Fire: 
		print ("Fire Spawned")
		await get_tree().create_timer(3.0).timeout
		spread_fire(node.current_tile_coords, 3)
		node.queue_free()

# Fire has been extinguished, need to change floor to Burned/Coals State
func _on_child_exiting_tree(node):
	if node is Fire:
		# TODO
		print("Fire Extinguished")

# Function to check surrounding floor tiles are valid and add_child(fire)
# to nearby tiles a random amount
func spread_fire(TILE,X):
	# TODO
	var surroundingtiles = []
	for a in range(-X,X):
		for b in range(-X,X):
			var currenttile = Vector2(a,b)
			if !surroundingtiles.has(currenttile) and currenttile != TILE:
				surroundingtiles.append(currenttile)
