extends Node2D

const StingerScene: PackedScene = preload("res://scenes/stinger.tscn")
const MissilePowerupScene: PackedScene = preload("res://scenes/missile_powerup.tscn")
const EnemyDeathEffectScene: PackedScene = preload("res://scenes/enemy_death_effect.tscn")

@onready var stinger_pivot: Marker2D = $StingerPivot
@onready var muzzle: Marker2D = $StingerPivot/Muzzle
@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var state_timer: Timer = $StateTimer

@export var acceleration: int = 150
@export var max_velocity: int = 400
@export var targets: Array[NodePath]

var STATE_OPTIONS: Array[Callable] = [fire_state, fire_state, rush_state, rush_state]
var state_options_left: Array[Callable] = []
var state: Callable = recenter_state: set = set_state
var state_init: bool = true: get = get_state_init
var velocity: Vector2 = Vector2.ZERO
var bullet_rotation: int = 17
var rush_state_length: int = 5
var fire_state_length: int = 5

@onready var statistics: Statistics = $Statistics


func set_state(value: Callable) -> void:
	state = value
	state_init = true

func get_state_init() -> bool:
	var was: bool = state_init
	state_init = false
	return was

func _ready() -> void:
	if WorldStash.retrieve("first_boss", "freed"):
		queue_free()

func _process(delta: float) -> void:
	state.call(delta)

func rush_state(delta: float) -> void:
	if state_init:
		state_timer.start(randf_range(rush_state_length-1, rush_state_length+1))
		state_timer.timeout.connect(set_state.bind(decelerate_state), CONNECT_ONE_SHOT)
	var player: Player = MainInstances.player
	if not player is Player: return
	var direction: Vector2 = global_position.direction_to(player.global_position)
	velocity = velocity.move_toward(direction * max_velocity, acceleration * delta)
	#velocity = clamp(Vector2.ZERO, max_velocity, velocity.move_toward(Vector2.ZERO, acceleration * delta))
	move(delta)
	
func fire_state(_delta: float) -> void:
	if state_init:
		state_timer.start(randf_range(fire_state_length-1, fire_state_length+1))
		state_timer.timeout.connect(set_state.bind(recenter_state), CONNECT_ONE_SHOT)
	if fire_rate_timer.time_left == 0:
		stinger_pivot.rotation_degrees += bullet_rotation
		fire_rate_timer.start()
		var stinger: Node2D = Utils.instantiate_scene_on_world(StingerScene, muzzle.global_position)
		stinger.rotation = stinger_pivot.rotation
		stinger.update_velocity()
		
func recenter_state(_delta: float) -> void:
	assert(not targets.is_empty())
	if state_init: 
		var center_node: Node = get_node(targets.pick_random())
		var tween: Tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "global_position", center_node.global_position, 2.0)
		await tween.finished
		state_timer.start(0.5)
		await state_timer.timeout
		if state_options_left.is_empty():
			state_options_left = STATE_OPTIONS.duplicate()
			state_options_left.shuffle()
		state = state_options_left.pop_back()

func decelerate_state(delta: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, acceleration * delta)
	move(delta)
	if velocity == Vector2.ZERO:
		state = recenter_state

func move(delta: float) -> void:
	translate(velocity * delta)

func _on_hurtbox_hurt(_hitbox: Hitbox, damage: int) -> void:
	statistics.health -= damage

func _on_statistics_no_health() -> void:
	WorldStash.stash("first_boss", "freed", true)
	Utils.instantiate_scene_on_world(MissilePowerupScene, global_position)
	queue_free()
	for i in 10:
		Utils.instantiate_scene_on_world(EnemyDeathEffectScene, global_position+Vector2(randf_range(-16,16),randf_range(-16,16)))
