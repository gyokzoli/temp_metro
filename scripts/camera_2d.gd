extends Camera2D

@onready var timer: Timer = $Timer

var shake: float = 0


func _ready() -> void:
	Events.add_screenshake.connect(start_screenshake)
	Events.camera_limits_changed.connect(update_limits)

func _process(_delta: float) -> void:
	offset.x = randf_range(-shake, shake)
	offset.y = randf_range(-shake, shake)
		
func update_limits(left: int, right: int, top: int, bottom: int) -> void:
	limit_left = left
	limit_right = right
	limit_top = top
	limit_bottom = bottom
		
func start_screenshake(amount: int, duration: float) -> void:
	shake = amount
	timer.wait_time = duration
	timer.start()

func _on_timer_timeout() -> void:
	shake = 0
