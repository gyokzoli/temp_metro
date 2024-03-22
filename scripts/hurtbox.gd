class_name Hurtbox
extends Area2D


signal hurt(hitbox: Hitbox, damage: int)

func take_hit(hitbox: Hitbox, damage: int) -> void:
	hurt.emit(hitbox, damage)

