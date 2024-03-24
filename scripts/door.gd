class_name Door
extends Area2D

var active: bool = false

@export_file("*.tscn") var new_level_path: String
@export var connection: DoorConnection

@onready var right_cast: RayCast2D = $RightCast
@onready var left_cast: RayCast2D = $LeftCast

func get_direction() -> int:
	if left_cast.is_colliding(): return -1
	if right_cast.is_colliding(): return 1
	return 0
	
func _physics_process(_delta: float) -> void:
	var player: Player = MainInstances.player
	if not player is Player: return
	if not active: return
	if overlaps_body(player) and new_level_path:
		var player_direction: int = sign(player.velocity.x)
		var direction: int = get_direction()
		if player_direction == direction:
			Events.door_entered.emit(self)


func _on_timer_timeout() -> void:
	active = true
