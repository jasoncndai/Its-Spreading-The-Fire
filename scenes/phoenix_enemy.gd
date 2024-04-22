extends CharacterBody2D



@export var spore_scene: PackedScene = preload("res://scenes/spore.tscn")


@export_range(0.0, 2.0) var IDLE_ANIMATION_SPEED_SCALE: float = 1.0
@export_range(0.0, 2.0) var RUNNING_ANIMATION_SPEED_SCALE: float = 1.5


#CHANGE THESE VARIABLES WHEN USING FOR OTHER ENEMY TYPES
@onready var enemySprites = $phoenixDude
@export_range(0, 100, 1) var HEALTH = 60
@export_range(0.0, 100.0) var MOVEMENT_SPEED = 100
@export var SPORE_SPEED : = 250

var player: CharacterBody2D = null
var is_targeting_player = false
var can_take_damage = true


func _physics_process(delta):	
	enemySprites.play("_default")
	if is_targeting_player:		
		enemySprites.speed_scale = RUNNING_ANIMATION_SPEED_SCALE
	
		if (player.position.x - position.x) > 0:
			enemySprites.flip_h = false
		else:
			enemySprites.flip_h = true
	
	else:
		enemySprites.speed_scale = IDLE_ANIMATION_SPEED_SCALE



func start_chasing_the_player(body):
	player = body
	is_targeting_player = true

func stop_chasing_the_player(body):
	player = null
	is_targeting_player = false


func _on_targeting_range_body_entered(body):
	if body.is_in_group("player"):
		start_chasing_the_player(body)


func _on_targeting_range_body_exited(body):
	if body.is_in_group("player"):
		stop_chasing_the_player(body)


func damage(value: int):
	HEALTH -= value
	$enemyInvincibleFrames.start()
	can_take_damage = false
	
	if HEALTH <= 0:		
		self.queue_free()
		get_tree().change_scene_to_file("res://main.tscn")
		


func _on_enemy_invincible_frames_timeout():
	can_take_damage = true 


func _on_attack_cooldown_enemy_timeout():
	if is_targeting_player:
		var spore = spore_scene.instantiate() as RigidBody2D
		add_child(spore)
		spore.position = %sporeOrigin.position
		spore.rotation  = %sporeOrigin.get_angle_to(player.position)
		var velocity = Vector2(SPORE_SPEED, 0)
		spore.linear_velocity = velocity.rotated(rotation)
	
	#$attackCooldownEnemy.wait_time = randf_range(4, 10)
	$attackCooldownEnemy.wait_time = 0.5
	$attackCooldownEnemy.start()

