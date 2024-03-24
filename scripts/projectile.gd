class_name Projectile
extends Node2D

const ExplosionEffectScene: PackedScene = preload("res://scenes/explosion_effect.tscn")

@export var speed = 150

var velocity: Vector2 = Vector2.ZERO


func _process(delta) -> void:
	position += velocity * delta

func update_velocity() -> void:
	velocity.x = speed
	velocity = velocity.rotated(rotation)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_hitbox_body_entered(_body: Node2D) -> void:
	Utils.instantiate_scene_on_world(ExplosionEffectScene, global_position)
	queue_free()

func _on_hitbox_area_entered(_area: Area2D) -> void:
	Utils.instantiate_scene_on_world(ExplosionEffectScene, global_position)
	queue_free()
