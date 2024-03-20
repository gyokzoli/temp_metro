extends CharacterBody2D

#@export var acceleration : int = 512
#@export var max_velocity : int = 64
#@export var friction : int = 256
#@export var gravity : int = 200
#@export var jump_force : int = 128
#@export var max_fall_speed : int = 128
@export var acceleration : int = 900
@export var max_velocity : int = 90
@export var air_multiplier : int = 0.7
@export var friction : int = 256
@export var gravity : int = 900
@export var jump_force : int = 350
@export var max_fall_speed : int = 180


func _physics_process(delta):
	apply_gravity(delta)
	var input_axis : float = Input.get_axis("ui_left", "ui_right")
	if is_moving(input_axis):
		apply_horizontal_force(delta, input_axis)
	else:
		apply_friction(delta)
	apply_jump()
	move_and_slide()


func is_moving(input_axis: float):
	return input_axis != 0

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, max_fall_speed, gravity * delta)

func apply_horizontal_force(delta, input_axis : float):
	var multiplier = air_multiplier if not is_on_floor() else 1.0
	velocity.x = move_toward(velocity.x, input_axis * max_velocity, acceleration * multiplier * delta)
	
func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, friction * delta)

func apply_jump():
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = -jump_force
