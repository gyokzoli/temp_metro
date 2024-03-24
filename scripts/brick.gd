class_name Brick
extends StaticBody2D

func _ready() -> void:
	update_collision_layer()
	await get_tree().process_frame
	var id = WorldStash.get_id(self)
	if WorldStash.retrieve(id, "freed"): queue_free()


func update_collision_layer() -> void:
	set_collision_layer_value(1, is_visible_in_tree())

func _on_visibility_changed() -> void:
	update_collision_layer()
