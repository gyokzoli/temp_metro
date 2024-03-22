extends CharacterBody2D

const DustEffectScene = preload("res://scenes/dust_effect.tscn")

#@export var acceleration : int = 512
#@export var max_velocity : int = 64
#@export var friction : int = 256
#@export var gravity : int = 200
#@export var jump_force : int = 128
#@export var max_fall_speed : int = 128
@export var acceleration : int = 900
@export var max_velocity : int = 90
@export var air_multiplier : float = 0.7
@export var friction : int = 256
@export var gravity : int = 900
@export var jump_force : int = 350
@export var max_fall_speed : int = 180

@onready var animation_player = $AnimationPlayer
@onready var player_sprite_2d = $PlayerSprite2D
@onready var coyote_timer = $CoyoteTimer
@onready var player_blaster = $PlayerBlaster
@onready var fire_rate_timer: Timer = $FireRateTimer


func _physics_process(delta) -> void:
	apply_gravity(delta)
	var input_axis : float = Input.get_axis("left", "right")
	if is_moving(input_axis):
		apply_horizontal_force(delta, input_axis)
	else:
		apply_friction(delta)
	apply_jump()
	if Input.is_action_pressed("fire") and fire_rate_timer.time_left == 0:
		fire_rate_timer.start()
		player_blaster.fire_bullet()
	update_animations(input_axis)
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_edge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_edge:
		#coyote_timer.wait_time = 0.2
		coyote_timer.start()


func create_dust_effect() -> void:
	Utils.instantiate_scene_on_world(DustEffectScene, global_position + Vector2(0,8))
	
func is_moving(input_axis: float):
	return input_axis != 0

func apply_gravity(delta) -> void:
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, max_fall_speed, gravity * delta)

func apply_horizontal_force(delta, input_axis : float) -> void:
	var multiplier = air_multiplier if not is_on_floor() else 1.0
	velocity.x = move_toward(velocity.x, input_axis * max_velocity, acceleration * multiplier * delta)
	
func apply_friction(delta) -> void:
	velocity.x = move_toward(velocity.x, 0, friction * delta)

func apply_jump() -> void:
	if is_on_floor() or coyote_timer.time_left > 0.0:
		if Input.is_action_just_pressed("jump"):
			velocity.y = -jump_force
	if not is_on_floor():
		if Input.is_action_just_released("jump") and velocity.y < -jump_force / 2.0:
			velocity.y = -jump_force / 2.0

func update_animations(input_axis: float) -> void:
	player_sprite_2d.scale.x = sign(get_local_mouse_position().x)
	if abs(player_sprite_2d.scale.x) != 1: player_sprite_2d.scale.x = 1
	if is_moving(input_axis):
		animation_player.play("run")
		animation_player.speed_scale = input_axis * player_sprite_2d.scale.x
		#player_sprite_2d.scale.x = sign(input_axis)
	else:
		animation_player.play("idle")
	if not is_on_floor():
		animation_player.play("jump")

