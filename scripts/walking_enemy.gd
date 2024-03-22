extends CharacterBody2D

@export var speed : float = 30.0
@export var turns_at_legdes : bool = true

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var floor_cast: RayCast2D = $FloorCast
@onready var statistics: Node = $Statistics

var gravity : float = 200.0
var direction : float = 1.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if is_on_wall():
		turn_around()
	if is_at_ledge() and turns_at_legdes:
		turn_around()
	velocity.x = direction * speed
	sprite_2d.scale.x = direction
	move_and_slide()

func is_at_ledge() -> bool:
	return is_on_floor() and not floor_cast.is_colliding()
	
func turn_around() -> void:
	direction *= -1


func _on_hurtbox_hurt(_hitbox: Hitbox, damage: int) -> void:
	statistics.health -= damage

func _on_statistics_no_health() -> void:
	queue_free()
