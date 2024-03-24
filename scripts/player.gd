extends CharacterBody2D

const DustEffectScene: PackedScene = preload("res://scenes/dust_effect.tscn")
const JumpEffectScene: PackedScene = preload("res://scenes/jump_effect.tscn")
const WallJumpEffectScene: PackedScene = preload("res://scenes/wall_jump_effect.tscn")
@export var acceleration: int = 900
@export var max_velocity: int = 90
@export var air_multiplier: float = 0.7
@export var friction: int = 256
@export var air_friction: int = 64
@export var gravity: int = 900
@export var jump_force: int = 350
@export var max_fall_speed: int = 180
@export var wall_slide_speed: int = 42
@export var max_wall_slide_speed: int = 128

var double_jump: bool = false
var state: Callable = move_state

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_sprite_2d: Sprite2D = $PlayerSprite2D
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var player_blaster: Node2D = $PlayerBlaster
@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var drop_through_timer: Timer = $DropThroughTimer
@onready var camera_2d: Camera2D = $Camera2D
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var blinking_animation_player: AnimationPlayer = $BlinkingAnimationPlayer
@onready var center: Marker2D = $Center


func _ready() -> void:
	PlayerStats.no_health.connect(die)
	
func _enter_tree() -> void:
	MainInstances.player = self

func _exit_tree() -> void:
	MainInstances.player = null

func _physics_process(delta: float) -> void:
	state.call(delta)
	if Input.is_action_pressed("fire") and fire_rate_timer.time_left == 0:
		fire_rate_timer.start()
		player_blaster.fire_bullet()


func move_state (delta: float) -> void:
	apply_gravity(delta)
	var input_axis : float = Input.get_axis("left", "right")
	if is_moving(input_axis):
		apply_horizontal_force(delta, input_axis)
	else:
		apply_friction(delta)
	apply_jump()
	if Input.is_action_just_pressed("crouch"):
		set_collision_mask_value(2, false)
		drop_through_timer.start()
	update_animations(input_axis)
	var was_on_floor = is_on_floor()
	move_and_slide()
	var just_left_edge = was_on_floor and not is_on_floor() and velocity.y >= 0
	if just_left_edge:
		#coyote_timer.wait_time = 0.2
		coyote_timer.start()
	wall_check()

func wall_slide_state(delta: float) -> void:
	var wall_normal: int = int(get_wall_normal().x)
	animation_player.play("wall_slide")
	player_sprite_2d.scale.x = sign(wall_normal)
	#velocity.y = clampf(velocity.y, -wall_slide_speed, max_wall_slide_speed)
	wall_jump_check(wall_normal)
	wall_slide(delta)
	move_and_slide()
	wall_detach_check(delta, wall_normal)


func wall_slide(delta: float) -> void:
	var slide_speed: int = wall_slide_speed
	if Input.is_action_pressed("crouch"):
		slide_speed = max_wall_slide_speed
	velocity.y = move_toward(velocity.y, slide_speed, gravity * delta)

func wall_detach_check(delta: float, wall_axis: int) -> void:
	#if get_wall_normal() == Vector2.ZERO and not is_on_wall_only(): state = move_state
	if not is_on_wall_only(): state = move_state
	else:
		if Input.is_action_just_pressed("right") and wall_axis == 1:
			velocity.x = acceleration * delta
			state = move_state
		if Input.is_action_just_pressed("left") and wall_axis == -1:
			velocity.x = -acceleration * delta
			state = move_state

func wall_check() -> void:
	if is_on_wall_only():
		state = wall_slide_state
		create_dust_effect()

func wall_jump_check(wall_axis: float) -> void:
	if Input.is_action_just_pressed("jump"):
		velocity.x = wall_axis * max_velocity
		state = move_state
		double_jump = true
		jump(int(jump_force * 0.75), false)
		var wall_jump_effect_position = global_position + Vector2(wall_axis * 3.5, -2)
		var wall_jump_effect = Utils.instantiate_scene_on_world(WallJumpEffectScene, wall_jump_effect_position)
		wall_jump_effect.scale.x = wall_axis
		



func create_dust_effect() -> void:
	Utils.instantiate_scene_on_world(DustEffectScene, global_position + Vector2(0,8))
	
func is_moving(input_axis: float):
	return input_axis != 0

func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, max_fall_speed, gravity * delta)

func apply_horizontal_force(delta: float, input_axis : float) -> void:
	var multiplier = air_multiplier if not is_on_floor() else 1.0
	velocity.x = move_toward(velocity.x, input_axis * max_velocity, acceleration * multiplier * delta)
	
func apply_friction(delta: float) -> void:
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, air_friction * delta)

func apply_jump() -> void:
	if is_on_floor(): double_jump = true
	if is_on_floor() or coyote_timer.time_left > 0.0:
		if Input.is_action_just_pressed("jump"):
			jump(jump_force)
	if not is_on_floor():
		if Input.is_action_just_released("jump") and velocity.y < -jump_force / 2.0:
			velocity.y = -jump_force / 2.0
		if Input.is_action_just_pressed("jump") and double_jump:
			jump(int(jump_force * 0.75))
			double_jump = false

func jump(force: int, create_effect: bool = true) -> void:
		velocity.y = -force
		if create_effect: Utils.instantiate_scene_on_world(JumpEffectScene, global_position)

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

func die() -> void:
	camera_2d.reparent(get_tree().current_scene)
	queue_free()
	

func _on_drop_through_timer_timeout() -> void:
	set_collision_mask_value(2, true)

func _on_hurtbox_hurt(_hitbox: Hitbox, _damage: int) -> void:
	Events.add_screenshake.emit(3, 0.25)
	PlayerStats.health -= 1
	blinking_animation_player.play("blink")
	#hurtbox.is_invincible = true
	#await blinking_animation_player.animation_finished
	#hurtbox.is_invincible = false
