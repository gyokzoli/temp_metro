extends Node

var data: Dictionary = {
}

func get_id(node: Node) -> String:
	var level: Level = MainInstances.level
	return level.name + "_" + node.name + "_" + str(node.global_position)

func stash(id: String, key: String, value) -> void:
	if not data.has(id): data[id] = {}
	data[id][key] = value

func retrieve(id: String, key: String):
	if not data.has(id): return
	if not data[id].has(key): return
	return data[id][key]
