extends Node

var data: Dictionary = {
}

func get_id(node: Node) -> String:
	var world: Node2D = get_tree().current_scene
	var level: Node2D = world.level
	return level.name + "_" + node.name + "_" + str(node.global_position)

func stash(id: String, key: String, value: bool) -> void:
	data[id] = {}
	data[id][key] = value

func retrieve(id: String, key: String):
	if not data.has(id): return
	if not data[id].has(key): return
	return data[id][key]
