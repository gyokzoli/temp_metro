extends Projectile


func _ready() -> void:
	Sound.play(Sound.explosion)
	
func _on_hitbox_body_entered(body: Node2D) -> void:
	super(body)
	if body is Brick:
		var id: String = WorldStash.get_id(body)
		WorldStash.stash(id, "freed", true)
		body.queue_free()

