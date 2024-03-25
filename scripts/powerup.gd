class_name Powerup
extends Area2D

func _ready() -> void:
	#await get_tree().process_frame
	var id: String = WorldStash.get_id(self)
	if  WorldStash.retrieve(id, "freed"): queue_free()

func pickup() -> void:
	Sound.play(Sound.powerup, randf_range(0.8, 1.1), -20.0)
	var id: String = WorldStash.get_id(self)
	WorldStash.stash(id, "freed", true)
	queue_free()

func _on_body_entered(_body: Node2D) -> void:
	pickup()
