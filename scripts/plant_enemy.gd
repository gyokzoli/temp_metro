extends Node2D

const EnemyBulletScene: PackedScene = preload("res://scenes/enemy_bullet.tscn")
const EnemyDeathEffectScene: PackedScene = preload("res://scenes/enemy_death_effect.tscn")


@onready var statistics: Statistics = $Statistics
@onready var bullet_spawn_point: Marker2D = $BulletSpawnPoint
@onready var fire_direction: Marker2D = $FireDirection
@onready var death_effect_location: Marker2D = $DeathEffectLocation

@export var bullet_speed: int = 30
@export var spread: int = 30


func fire_bullet() -> void:
	var bullet: Projectile = Utils.instantiate_scene_on_level(EnemyBulletScene, bullet_spawn_point.global_position) as Projectile
	var direction: Vector2 = global_position.direction_to(fire_direction.global_position)
	#with the commendted out section, the enemy bullets are not rotated, only their vector
	#var velocity: Vector2 = direction.normalized() * bullet_speed
	#velocity = velocity.rotated(randf_range(-deg_to_rad(spread/2.0), deg_to_rad(spread/2.0)))
	#bullet.velocity = velocity
	#with this, the enemy bullets are rotated to their vector
	bullet.rotation = direction.angle()
	bullet.rotate(randf_range(-deg_to_rad(spread/2.0), deg_to_rad(spread/2.0)))
	bullet.speed = bullet_speed
	bullet.update_velocity()


func _on_hurtbox_hurt(_hitbox: Hitbox, damage: int) -> void:
	statistics.health -= damage

func _on_statistics_no_health() -> void:
	Utils.instantiate_scene_on_level(EnemyDeathEffectScene, death_effect_location.global_position)
	queue_free()


