extends ColorRect

var paused: bool = false:
	set(value):
		paused = value
		get_tree().paused = paused
		visible = paused
		if paused:
			Sound.play(Sound.pause, 1.0, -25.0)
		else:
			Sound.play(Sound.unpause, 1.0, -25.0)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		paused = not paused

func _on_resume_button_pressed() -> void:
	paused = false
	Sound.play(Sound.click, 1.0, -22.0)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
