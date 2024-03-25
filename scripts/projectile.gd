class_name Projectile
extends Node2D

const ExplosionEffectScene: PackedScene = preload("res://scenes/explosion_effect.tscn")
@onready var timer: Timer = $Timer

@export var speed: int = 150

var velocity: Vector2 = Vector2.ZERO
var screen_entered = false

func _process(delta) -> void:
	position += velocity * delta

func update_velocity() -> void:
	velocity.x = speed
	velocity = velocity.rotated(rotation)

func _ready() -> void:
	Sound.play(Sound.bullet, randf_range(0.6, 1.2), -5)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_hitbox_body_entered(_body: Node2D) -> void:
	Utils.instantiate_scene_on_level(ExplosionEffectScene, global_position)
	queue_free()

func _on_hitbox_area_entered(_area: Area2D) -> void:
	Utils.instantiate_scene_on_level(ExplosionEffectScene, global_position)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	screen_entered = true

func _on_timer_timeout() -> void:
	if screen_entered: return
	queue_free()
