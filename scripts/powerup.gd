class_name Powerup
extends Area2D

func _ready() -> void:
	await get_tree().process_frame
	var id = WorldStash.get_id(self)
	var freed = WorldStash.retrieve(id, "freed")
	if freed: queue_free()

func pickup() -> void:
	var id: String = WorldStash.get_id(self)
	WorldStash.stash(id, "freed", true)
	queue_free()

func _on_body_entered(_body: Node2D) -> void:
	pickup()
