extends Node2D

const EnemyDeathEffectScene: PackedScene = preload("res://scenes/enemy_death_effect.tscn")

enum DIRECTION {LEFT = -1, RIGHT = 1}
@export var crawling_direction = DIRECTION.RIGHT
@export var max_speed: int = 200

@onready var floor_cast: RayCast2D = $FloorCast
@onready var wall_cast: RayCast2D = $WallCast
@onready var statistics: Statistics = $Statistics


func _ready() -> void:
	wall_cast.target_position.x *= crawling_direction
	
func _process(delta: float) -> void:
	if wall_cast.is_colliding():
		global_position = wall_cast.get_collision_point()
		var wall_normal: Vector2 = wall_cast.get_collision_normal()
		rotation = wall_normal.rotated(deg_to_rad(90)).angle()
	else:
		floor_cast.rotation_degrees = -max_speed * crawling_direction * delta
		if floor_cast.is_colliding():
			global_position = floor_cast.get_collision_point()
			var floor_normal = floor_cast.get_collision_normal()
			rotation = floor_normal.rotated(deg_to_rad(90)).angle()
		else:
			rotation_degrees += crawling_direction * 2


func _on_hurtbox_hurt(_hitbox: Hitbox, damage: int) -> void:
	statistics.health -= damage

func _on_statistics_no_health() -> void:
	Utils.instantiate_scene_on_world(EnemyDeathEffectScene, global_position)
	queue_free()
	
