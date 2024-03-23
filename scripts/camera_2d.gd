extends Camera2D

@onready var timer: Timer = $Timer

var shake: float = 0


func _ready() -> void:
	Events.add_screenshake.connect(start_screenshake)

func _process(_delta: float) -> void:
	offset.x = randf_range(-shake, shake)
	offset.y = randf_range(-shake, shake)
		
func start_screenshake(amount: int, duration: float) -> void:
	shake = amount
	timer.wait_time = duration
	timer.start()

func _on_timer_timeout() -> void:
	shake = 0
