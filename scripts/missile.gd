extends Projectile

func _on_hitbox_body_entered(body: Node2D) -> void:
	super(body)
	if body is Brick:
		body.queue_free()
