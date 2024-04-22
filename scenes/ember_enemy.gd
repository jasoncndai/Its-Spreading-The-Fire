extends CharacterBody2D


@export_range(0.0, 2.0) var IDLE_ANIMATION_SPEED_SCALE: float = 1.0
@export_range(0.0, 2.0) var RUNNING_ANIMATION_SPEED_SCALE: float = 1.5


#CHANGE THESE VARIABLES WHEN USING FOR OTHER ENEMY TYPES
@onready var enemySprites = $emberDude
@export_range(0, 100, 1) var HEALTH = 15
@export_range(0.0, 100.0) var MOVEMENT_SPEED = 100

var player: CharacterBody2D = null
var is_chasing_player = false
var can_take_damage = true


func _enter_tree():
	pass

func _physics_process(delta):
	enemySprites.play("_default")
	if is_chasing_player:
		position.x = move_toward(position.x, player.position.x, MOVEMENT_SPEED*delta)
		position.y = move_toward(position.y, player.position.y, MOVEMENT_SPEED*delta)
		move_and_slide()
		
		enemySprites.speed_scale = RUNNING_ANIMATION_SPEED_SCALE
	
		if (player.position.x - position.x) > 0:
			enemySprites.flip_h = true
		else:
			enemySprites.flip_h = false
	
	else:
		enemySprites.speed_scale = IDLE_ANIMATION_SPEED_SCALE


func start_chasing_the_player(body):
	player = body
	is_chasing_player = true

func stop_chasing_the_player(body):
	player = null
	is_chasing_player = false


func _on_chase_range_body_entered(body):
	if body.is_in_group("player"):
		start_chasing_the_player(body)


func _on_chase_range_body_exited(body):
	if body.is_in_group("player"):
		stop_chasing_the_player(body)


func damage(value: int):
	HEALTH -= value
	$enemyInvincibleFrames.start()
	can_take_damage = false
	
	if HEALTH <= 0:
		self.queue_free()


func _on_enemy_invincible_frames_timeout():
	can_take_damage = true 
