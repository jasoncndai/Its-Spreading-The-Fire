extends CharacterBody2D


@export var BULLET_SCENE : PackedScene
@export var PLAYER_SPEED : float = 80.0
@export var BULLET_SPEED : = 300
@export_range(0.0, 1.0) var IDLE_ANIMATION_SPEED_SCALE: float = 0.8
@export_range(0.0, 1.0) var RUNNING_ANIMATION_SPEED_SCALE: float = 1.0

#Quick and easy player reference
@onready var playerSprites = %animatedSprite

#Combat Variables
var enemy_in_attack_range = false
var damage_recieved_cooldown = true
var playerhealth = 5
var player_alive = true


func _enter_tree():
	%animatedSprite.play()

func _physics_process(delta):
# MOVEMENT
	var mouse_position
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if direction.x:
		velocity.x = direction.x * PLAYER_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, PLAYER_SPEED)

	if direction.y:
		velocity.y = direction.y * PLAYER_SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, PLAYER_SPEED)

	move_and_slide()
	
# SHOOTING
	if Input.is_action_pressed("MOUSE_LEFT"):
		shoot()
	
	if Input.is_action_just_pressed("MOUSE_RIGHT"):
		melee()

# ENEMY ATTACKS
	enemy_attack()

	if playerhealth <= 0:
		player_alive = false  # ADD GAMEOVER SCREEN/RETURN TO MAIN MENU
		playerhealth = 0
		print("player died")
		self.queue_free()
		get_tree().change_scene_to_file("res://main.tscn")
	

# FOOTSTEPS 
# ANIMATION
	if velocity.is_zero_approx():
		%animatedSprite.speed_scale = IDLE_ANIMATION_SPEED_SCALE
		$Footsteps.stop()
		$FootstepTimer.stop()
	else:
		%animatedSprite.speed_scale = RUNNING_ANIMATION_SPEED_SCALE
		if ($FootstepTimer.time_left == 0):
			$Footsteps.play()
			$FootstepTimer.start()

func _input(event):
	if event is InputEventMouseMotion:
		look_at(get_global_mouse_position())

#COMBAT SECTION
func shoot():
	var bullet = BULLET_SCENE.instantiate() as RigidBody2D
	bullet.position = %bulletOrigin.global_position
	bullet.rotation  = %bulletOrigin.global_rotation
	var velocity = Vector2(BULLET_SPEED, 0)
	bullet.linear_velocity = velocity.rotated(rotation)
	if ($attackCooldown.time_left == 0):
		playerSprites.animation = "attack"
		$Whoosh.play()
		owner.add_child(bullet, true)
		$attackCooldown.start()

func melee():
	if ($attackCooldown.time_left == 0):
		playerSprites.animation = "attack"
		$Whoosh.play()
		Game.player_melee_attack = true
		$attackCooldown.start()

func _on_attack_cooldown_timeout() -> void:
	$attackCooldown.stop()
	Game.player_melee_attack = false
	playerSprites.animation = "_default"


func _on_player_hitbox_body_entered(body):
	if body.is_in_group("enemies"):
		enemy_in_attack_range = true

func _on_player_hitbox_body_exited(body):
	if body.is_in_group("enemies"):
		enemy_in_attack_range = false

func enemy_attack():
	if enemy_in_attack_range and damage_recieved_cooldown == true:
		playerhealth = playerhealth - 1
		damage_recieved_cooldown = false
		$invincibilityFrames.start()
		print(playerhealth)

func _on_invincibility_frames_timeout():
	damage_recieved_cooldown = true
