extends ColorRect


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_load_button_pressed() -> void:
	print("load save game")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
