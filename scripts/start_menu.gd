extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_load_button_pressed() -> void:
	print("load save game")

func _on_quit_button_pressed() -> void:
	get_tree().quit()