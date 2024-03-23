class_name Statistics
extends Node

@export var max_health: int = 3: set = _set_max_health, get = _get_max_health
@onready var health: int = max_health: set = _set_health, get = _get_health

signal no_health
signal health_changed
signal max_health_changed

func _get_max_health() -> int:
	return max_health
	
func _set_max_health(value: int) -> void:
	max_health = value
	max_health_changed.emit()

func _get_health() -> int:
	return health

func _set_health(value: int) -> void:
	health = clamp(value, 0, max_health)
	health_changed.emit()
	if health <= 0: no_health.emit()
