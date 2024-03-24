class_name Powerup
extends Area2D


func pickup() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	pickup()
