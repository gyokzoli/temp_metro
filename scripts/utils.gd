extends Node

func instantiate_scene_on_world(scene: PackedScene, position: Vector2) -> Node2D:
	var world: Node = get_tree().current_scene
	var instance = scene.instantiate()
	world.add_child.call_deferred(instance)
	instance.global_position = position
	return instance

func instantiate_scene_on_level(scene: PackedScene, position: Vector2) -> Node2D:
	var world: Node = get_tree().current_scene
	if not world is World: return
	var level: Node2D = world.level
	var instance: Node = scene.instantiate()
	level.add_child.call_deferred(instance)
	instance.global_position = position
	return instance
