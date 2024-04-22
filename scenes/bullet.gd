class_name Bullet
extends RigidBody2D
@onready var bulletSprites = $Sprite2D


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	bulletSprites.play("_default")
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node) -> void:
	if (body.has_method('damage')):
		body.damage(3)
	hide()
	queue_free()
