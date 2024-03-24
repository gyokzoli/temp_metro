extends ColorRect

var paused: bool = false:
	set(value):
		paused = value
		get_tree().paused = paused
		visible = paused

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		paused = not paused

func _on_resume_button_pressed() -> void:
	paused = false

func _on_quit_button_pressed() -> void:
	get_tree().quit()
