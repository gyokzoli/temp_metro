extends Node2D

@export var speed = 250

var velocity = Vector2.ZERO


func _process(delta) -> void:
	position += velocity * delta

func update_velocity() -> void:
	velocity.x = speed
	velocity = velocity.rotated(rotation)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
