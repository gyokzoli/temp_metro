extends Control

@onready var full: TextureRect = $Full
@onready var empty: TextureRect = $Empty


func _ready() -> void:
	update_health_ui()
	update_max_health_ui()
	PlayerStats.health_changed.connect(update_health_ui)
	PlayerStats.max_health_changed.connect(update_max_health_ui)

func update_health_ui() -> void:
	full.size.x = PlayerStats.health * 5 + 1
	
func update_max_health_ui() -> void:
	empty.size.x = PlayerStats.max_health * 5 + 1
