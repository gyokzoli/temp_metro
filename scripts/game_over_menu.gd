extends ColorRect


func _on_load_button_pressed() -> void:
	Sound.play(Sound.click, 1.0, -10.0)
	SaveManager.is_loading = true
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
