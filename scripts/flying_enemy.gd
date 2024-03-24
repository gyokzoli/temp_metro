extends CharacterBody2D

const EnemyDeathEffectScene: PackedScene = preload("res://scenes/enemy_death_effect.tscn")

@export var acceleration: int = 100
@export var max_speed: int = 40

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var statistics: Statistics = $Statistics
@onready var waypoint_pathfinding: Node2D = $WaypointPathfinding


func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	var player = MainInstances.player
	if player is CharacterBody2D:
		move_toward_position(waypoint_pathfinding.pathfinding_next_position, delta)
	

func move_toward_position(target_position: Vector2, delta: float) -> void:
	var direction: Vector2 = global_position.direction_to(target_position)
	velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
	animated_sprite_2d.flip_h = global_position < target_position
	move_and_slide()


func _on_hurtbox_hurt(_hitbox: Hitbox, damage: int) -> void:
	statistics.health -= damage

func _on_statistics_no_health() -> void:
	Utils.instantiate_scene_on_world(EnemyDeathEffectScene, global_position)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	set_physics_process(true)
