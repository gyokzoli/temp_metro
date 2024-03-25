class_name World
extends Node2D

@onready var level: Node2D = $Level1

func _enter_tree() -> void:
	MainInstances.world = self

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
	Events.door_entered.connect(change_levels)
	Events.player_died.connect(game_over)
	Music.play(Music.main_theme)
	#await get_tree().create_timer(1.0).timeout
	if SaveManager.is_loading:
		SaveManager.load_game()
		SaveManager.is_loading = false

func _exit_tree() -> void:
	MainInstances.world = null

func load_level(file_path: String) -> void:
	level.queue_free()
	level.name = level.name + "_OLD"
	var level_scene: PackedScene = load(file_path)
	var new_level: Node2D = level_scene.instantiate()
	add_child(new_level)
	level = new_level

func change_levels(door: Node2D) -> void:
	var player: CharacterBody2D = MainInstances.player
	if not player is Player: return
	level.queue_free()
	var new_level: Node2D = load(door.new_level_path).instantiate()
	add_child(new_level)
	level = new_level
	var doors: Array[Node] = get_tree().get_nodes_in_group("doors")
	for found_door in doors:
		if found_door == door: continue
		if found_door.connection != door.connection: continue
		var y_offset: float = player.global_position.y - door.global_position.y
		player.global_position = found_door.global_position + Vector2(0, y_offset)

func game_over() -> void:
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/game_over_menu.tscn")
