extends Node2D

const EnemyBulletScene: PackedScene = preload("res://scenes/enemy_bullet.tscn")

@onready var statistics: Statistics = $Statistics
@onready var bullet_spawn_point: Marker2D = $BullerSpawnPoint
@onready var fire_direction: Marker2D = $FireDirection

@export var bullet_speed: int = 30
@export var spread: int = 30


func fire_bullet() -> void:
	var bullet: Projectile = Utils.instantiate_scene_on_world(EnemyBulletScene, bullet_spawn_point.global_position) as Projectile
	var direction: Vector2 = global_position.direction_to(fire_direction.global_position)
	bullet.rotation = direction.angle()
	bullet.rotate(randf_range(-deg_to_rad(spread/2), deg_to_rad(spread/2)))
	bullet.speed = bullet_speed
	bullet.update_velocity()


func _on_hurtbox_hurt(hitbox: Hitbox, damage: int) -> void:
	statistics.health -= damage

func _on_statistics_no_health() -> void:
	queue_free()


