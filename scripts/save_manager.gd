extends Node

const TEST_PATH: String = "res://save.txt"
const PROD_PATH: String = "res://metroidvania.save"

var save_path: String = TEST_PATH
var is_loading: bool = false

func save_game() -> void:
	#SAVE_LEVEL
	WorldStash.stash("level", "file_path", MainInstances.level.scene_file_path)
	#SAVE_PLAYER
	WorldStash.stash("player", "x", MainInstances.player.global_position.x)
	WorldStash.stash("player", "y", MainInstances.player.global_position.y)
	PlayerStats.stash_stats()
	var save_file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	var data_string: String = JSON.stringify(WorldStash.data)
	save_file.store_string(data_string)
	save_file.close()
	
func load_game() -> void:
	var save_file: FileAccess = FileAccess.open(save_path, FileAccess.READ)
	if not save_file is FileAccess: return
	var data: Dictionary = JSON.parse_string(save_file.get_line())
	WorldStash.data = data
	
	#LOAD_LEVEL
	var file_path: String = WorldStash.retrieve("level", "file_path")
	MainInstances.world.load_level(file_path)
	#LOAD_PLAYER
	var player_x: float = WorldStash.retrieve("player", "x")
	var player_y: float = WorldStash.retrieve("player", "y")
	PlayerStats.retrieve_stats()
	MainInstances.player.global_position = Vector2(player_x, player_y)
	save_file.close()
	
