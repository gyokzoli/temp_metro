extends Node2D

const EnemyDeathEffectScene: PackedScene = preload("res://scenes/enemy_death_effect.tscn")

enum DIRECTION {LEFT = -1, RIGHT = 1}
@export var crawling_direction = DIRECTION.RIGHT
@export var max_speed: int = 200
@export var spin_speed: int = 600

var state: Callable = crawling_state
var gravity: int = 150

@onready var floor_cast: RayCast2D = $FloorCast
@onready var wall_cast: RayCast2D = $WallCast
@onready var statistics: Statistics = $Statistics
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	wall_cast.target_position.x *= crawling_direction
	
func _process(delta: float) -> void:
	state.call(delta)

func crawling_state(delta: float) -> void:
	animated_sprite_2d.play("crawl")
	if wall_cast.is_colliding():
		global_position = wall_cast.get_collision_point()
		var wall_normal: Vector2 = wall_cast.get_collision_normal()
		rotation = wall_normal.rotated(deg_to_rad(90)).angle()
	else:
		floor_cast.rotation_degrees = -max_speed * crawling_direction * delta
		var while_limit: int = 30
		while not floor_cast.is_colliding():
			rotation_degrees += crawling_direction
			floor_cast.force_raycast_update()
			while_limit -=1
			if while_limit <= 0:
				state = falling_state
				break
		if floor_cast.is_colliding():
			global_position = floor_cast.get_collision_point()
			var floor_normal: Vector2 = floor_cast.get_collision_normal()
			rotation = floor_normal.rotated(deg_to_rad(90)).angle()

func falling_state(delta: float) -> void:
	animated_sprite_2d.play("fall")
	rotation_degrees += crawling_direction * spin_speed * delta
	position.y += gravity * delta
	if floor_cast.is_colliding() or wall_cast.is_colliding():
		state = crawling_state
	
func _on_hurtbox_hurt(_hitbox: Hitbox, damage: int) -> void:
	statistics.health -= damage

func _on_statistics_no_health() -> void:
	Utils.instantiate_scene_on_level(EnemyDeathEffectScene, global_position)
	queue_free()
	
