class_name Fire
extends Area2D


@onready var anim = get_node("AnimatedSprite2D")
var current_tilemap: TileMap
var current_tile_coords

func _ready():
	anim.play("Start")
	
	

func _physics_process(delta):
	anim.play("Idle")

func _on_body_entered(body):
	# burns player for hitting it
	if body.name == "player":
		Game.playerHP -= 1

# Set coordinates of current Tile cell the fire is on, store in variable
func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	print("Entered")
	if body is TileMap:
		current_tilemap = body
		current_tile_coords = current_tilemap.get_coords_for_body_rid(body_rid)
		print(current_tilemap)
		print(current_tile_coords)
